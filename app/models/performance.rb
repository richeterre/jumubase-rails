# == Schema Information
#
# Table name: performances
#
#  id                  :integer          not null, primary key
#  stage_time          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  tracing_code        :string(255)
#  age_group           :string(255)
#  predecessor_id      :integer
#  stage_venue_id      :integer
#  contest_category_id :integer
#

# -*- encoding : utf-8 -*-
class Performance < ActiveRecord::Base
  # Attributes that are accessible to everyone (needed for signup)
  attr_accessible :contest_category_id, :pieces_attributes, :appearances_attributes

  amoeba do
    enable # Allow deep duplication
  end

  belongs_to  :contest_category
  belongs_to  :predecessor,   class_name: "Performance", inverse_of: :successor,
                              include: { contest_category: { contest: :host } }
  belongs_to  :stage_venue,   class_name: "Venue"
  has_one     :successor,     class_name: "Performance", foreign_key: "predecessor_id",
                              inverse_of: :predecessor, dependent: :nullify
  has_many    :appearances,   inverse_of: :performance, dependent: :destroy
  has_many    :participants,  through: :appearances
  has_many    :pieces,        inverse_of: :performance, dependent: :destroy

  delegate :contest, to: :contest_category
  delegate :category, to: :contest_category

  accepts_nested_attributes_for :pieces,      allow_destroy: true
  accepts_nested_attributes_for :appearances, allow_destroy: true

  validates :contest_category_id, presence: true

  validate :contest_and_venue_hosts_match

  validate :require_one_appearance
  validate :require_one_piece

  validate :check_role_combinations

  validate :stage_time_in_contest_days
  validate :stage_field_values_complete

  before_create :add_unique_tracing_code
  before_save :update_age_group

  # Returns stage time in contest time zone
  def stage_time_in_tz
    if self.stage_time.nil?
      nil
    else
      self.stage_time.in_time_zone(self.contest.host.time_zone)
    end
  end

  # Returns all performances in current round and year
  def self.current
    self.in_contest(Contest.current)
  end

  # Returns all performances in contests that are currently open (for signup/edits)
  def self.in_open_contest
    self.in_contest(Contest.open)
  end

  # Returns all performances in given contest
  def self.in_contest(contest_id)
    joins(:contest_category)
    .select("performances.*, contest_categories.contest_id")
    .where(contest_categories: { contest_id: contest_id })
  end

  # Returns all performances that advanced from given contest(s)
  def self.advanced_from_contest(contest_ids)
    joins("INNER JOIN performances AS predecessors ON predecessors.id = performances.predecessor_id")
    .joins("INNER JOIN contest_categories AS predecessor_ccs ON predecessor_ccs.id = predecessors.contest_category_id")
    .where("predecessor_ccs.contest_id IN (?)", contest_ids)
  end

  # Returns all performances in given category
  def self.in_category(category_id)
    joins(:contest_category)
    .where(contest_categories: { category_id: category_id })
  end

  # Returns all performances in given contest category
  def self.in_contest_category(contest_category_id)
    where(contest_category_id: contest_category_id)
  end

  # Returns all performances in given age group
  def self.in_age_group(age_group)
    where(age_group: age_group)
  end

  # Returns all performances in given genre
  def self.in_genre(genre)
    joins(contest_category: :category)
    .where(categories: { genre: genre })
  end

  # Returns all classical performances
  def self.classical
    self.in_genre('classical')
  end

  # Returns all Kimu performances
  def self.kimu
    self.in_genre('kimu')
  end

  # Returns all popular performances
  def self.popular
    self.in_genre('popular')
  end

  # Returns all performances on a given date, or unschedule if not date given
  def self.on_date(date)
    if date.nil?
      where(stage_time: nil)
    else
      if date.class == String
        # Convert to Date object first
        date = Date.new(*date.split('-').map(&:to_i))
      end
      where(stage_time: date...(date + 1.day))
    end
  end

  # Returns all performances whose stage venue is the given venue
  def self.at_stage_venue(venue_id)
    where(stage_venue_id: venue_id)
  end

  # Returns all performances whose stage venue is empty or the given venue
  def self.venueless_or_at_stage_venue(venue_id)
    where("performances.stage_venue_id IS NULL OR performances.stage_venue_id = ?", venue_id)
  end

  # Orders performances chronologically by stage date
  def self.stage_order
    order("performances.stage_time").browsing_order
  end

  # Orders performances by category, then age group (smallest first)
  def self.browsing_order
    includes(contest_category: :category)
    .order('categories.genre, categories.solo DESC, categories.name, performances.age_group')
  end

  # Return the host the performance is associated with
  def associated_host
    case self.contest.round
    when 1
      self.contest.host
    when 2
      if self.predecessor
        self.predecessor.contest.host
      end
    end
  end

  # Return the country the performance is associated with
  def associated_country_code
    self.associated_host.try(:country_code)
  end

  # Return participant of performance that has a soloist role
  def soloist
    self.appearances.select { |a| a.solo? }.first
  end

  # Return all participants of performance that have an accompanist role
  def accompanists
    self.appearances.with_role('accompanist').map(&:participant)
  end

  # Return all ensemble appearances of performance
  def ensemble_appearances
    self.appearances.with_role('ensemblist')
  end

  def duration
    if self.pieces.empty?
      0 # Pretty short show
    else
      # Sum durations (in seconds) of all pieces together
      self.pieces.map(&:duration).inject { |sum, d| sum + d }
    end
  end

  def rounded_duration
    # Round up in five-minute steps (5, 10, 15, ...)
    (self.duration.to_f / 300).ceil * 300
  end

  def rounded_end_time
    # Time the performance is scheduled to end (using rounded duration)
    self.stage_time + self.rounded_duration.seconds
  end

  # Return whether the performance as a whole can migrate to next round
  def advances_to_next_round?
    # Don't advance if category's maximum round is reached
    if self.contest.round >= self.category.max_round
      return false
    end

    # Prevent from advancing if the age group is not officially allowed in this category
    age_group_index = JUMU_AGE_GROUPS.index(self.age_group)
    return false if age_group_index < JUMU_AGE_GROUPS.index(self.category.official_min_age_group)
    return false if age_group_index > JUMU_AGE_GROUPS.index(self.category.official_max_age_group)

    if self.soloist
      self.soloist.may_advance_to_next_round? # Soloist determines
    else
      self.appearances.first.may_advance_to_next_round? # Use some ensemblist
    end
  end

  private

    def add_unique_tracing_code
      begin
        # Generate a random 5-digit code, avoiding leading zero
        code = rand(10000..99999).to_s
      end while Performance.where(tracing_code: code).exists?

      self.tracing_code = code
    end

    def update_age_group
      self.appearances.each do |appearance|
        if appearance.solo? || appearance.ensemble?
          # Use age group of soloist or first ensemblist
          self.age_group = appearance.age_group
          return
        end
      end
      # Else empty the age group
      self.age_group = nil
    end

    def contest_and_venue_hosts_match
      if !stage_venue.nil? and contest.host != stage_venue.host
        errors.add(:base, :contest_and_venue_hosts_must_match)
      end
    end

    def require_one_appearance
      errors.add(:base, :needs_one_appearance) if appearances_empty?
    end

    def require_one_piece
      errors.add(:base, :needs_one_piece) if pieces_empty?
    end

    def check_role_combinations
      if !appearances_empty? # Do nil check and ignore appearances marked for destruction
        # Check if there are many soloists
        if appearances.select { |a| a.solo? }.size > 1
          errors.add(:base, :cannot_have_many_soloists)
        end

        # Check if all participants are accompanists
        if appearances.all? {|a| a.accompaniment? }
          errors.add(:base, :cannot_have_mere_accompanists)
        end

        # Check if there is a lonely ensemblist
        if appearances.size == 1 && appearances.all? {|a| a.ensemble? }
          errors.add(:base, :cannot_have_single_ensemblist)
        end

        # Check if there are both soloists and ensemblists
        has_soloists = appearances.select {|a| a.solo? }.size > 0
        has_ensemblists = appearances.select {|a| a.ensemble? }.size > 0
        if has_soloists && has_ensemblists
          errors.add(:base, :cannot_have_soloists_and_ensemblists)
        end
      end
    end

    def stage_time_in_contest_days
      # TODO: Take time zone into account for contest.begins and contest.ends
      if stage_time && (stage_time < contest.begins || stage_time > contest.ends + 1.day)
        errors.add(:base, :cannot_have_stage_time_outside_contest_days)
      end
    end

    def stage_field_values_complete
      if stage_time && !stage_venue_id || !stage_time && stage_venue_id
        errors.add(:base, :cannot_have_incomplete_stage_field_values)
      end
    end

    def appearances_empty?
      appearances.empty? || appearances.all? { |appearance| appearance.marked_for_destruction? }
    end

    def pieces_empty?
      pieces.empty? || pieces.all? { |piece| piece.marked_for_destruction? }
    end
end
