# == Schema Information
#
# Table name: performances
#
#  id              :integer          not null, primary key
#  category_id     :integer
#  competition_id  :integer
#  stage_venue_id  :integer
#  warmup_time     :datetime
#  stage_time      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  tracing_code    :string(255)
#  warmup_venue_id :integer
#  age_group       :string(255)
#

# -*- encoding : utf-8 -*-
class Performance < ActiveRecord::Base
  # Attributes that are accessible to everyone (needed for signup)
  attr_accessible :category_id, :competition_id,
      :pieces_attributes, :appearances_attributes

  belongs_to  :category
  belongs_to  :competition
  belongs_to  :warmup_venue,  class_name: "Venue"
  belongs_to  :stage_venue,   class_name: "Venue"
  has_many    :appearances,   inverse_of: :performance, dependent: :destroy
  has_many    :participants,  through: :appearances
  has_many    :pieces,        inverse_of: :performance, dependent: :destroy

  accepts_nested_attributes_for :pieces,      allow_destroy: true
  accepts_nested_attributes_for :appearances, allow_destroy: true

  validates :category_id,     presence: true
  validates :competition_id,  presence: true

  validate :require_one_appearance
  validate :require_one_piece

  validate :check_role_combinations

  before_create :add_unique_tracing_code
  before_save :update_age_group

  # Override getters to always get times in competition time zone
  def warmup_time
    super().in_time_zone(self.competition.host.time_zone) if super()
  end

  def stage_time
    super().in_time_zone(self.competition.host.time_zone) if super()
  end

  # Returns all performances in current round and year
  def self.current
    where(competition_id: Competition.current)
  end

  # Returns all performances in given competition
  def self.in_competition(competition_id)
    where(competition_id: competition_id)
  end

  # Returns all performances in given category
  def self.in_category(category_id)
    where(category_id: category_id)
  end

  # Returns all performances in given age group
  def self.in_age_group(age_group)
    where(age_group: age_group)
  end

  # Returns all performances in given genre
  def self.in_genre(popular)
    popular == 1 ? popular : classical
  end

  # Returns all performances in classical categories
  def self.classical
    joins(:category).where('categories.popular = FALSE')
  end

  # Returns all performances in pop categories
  # (using "popular" here to steer clear of Ruby #pop method)
  def self.popular
    joins(:category).where('categories.popular = TRUE')
  end

  # Returns all performances with at least one participant from a listed country
  scope :from_countries, lambda { |countries|
    joins(:participants).
    where(participants: { country_id: countries }).
    group("performances.id")
  }

  # Returns all performances sent on from a given host
  scope :from_host, lambda { |host_id|
    joins(:first_competition).
    where(competitions: { host_id: host_id })
  }

  # Returns all performances scheduled on a given date,
  # or unscheduled if no date given
  scope :on_date, lambda { |date|
    if date.nil?
      where(stage_time: nil)
    else
      if date.class == String
        date = Date.new(*date.split('-').map(&:to_i))
      end
      where(stage_time: date...(date + 1.day))
    end
  }

  # Returns all performances with given venue as either warmup or stage
  scope :at_venue, lambda { |venue|
    where("warmup_venue_id = ? OR stage_venue_id = ?", venue, venue)
  }

  # Orders performances chronologically by stage date
  def self.stage_order
    order(:stage_time)
  end

  # Orders performances by category, then age group (smallest first)
  def self.browsing_order
    joins(:category)
    .order('categories.popular, categories.solo DESC, categories.name, age_group')
  end

  def accompanists
    # Return all participants of performance that have an accompanist role
    self.appearances.with_role('B').map(&:participant)
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

  private

    def add_unique_tracing_code
      begin
        # Generates a random string of seven lowercase letters and numbers
        code = [('a'..'z'), (0..9)].map{ |i| i.to_a }.flatten.shuffle[0..6].join
      end while Performance.where(tracing_code: code).exists?

      self.tracing_code = code
    end

    def update_age_group
      self.appearances.each do |appearance|
        if appearance.solo?
          self.age_group = appearance.age_group # Use age group of soloist
          return
        end
      end
      # Else use that of first appearance, as they all have the same
      self.age_group = self.appearances.first.age_group
    end

    def require_one_appearance
      errors.add(:base, :needs_one_appearance) if appearances_empty?
    end

    def require_one_piece
      errors.add(:base, :needs_one_piece) if pieces_empty?
    end

    def check_role_combinations
      errors.add(:base, :cannot_have_many_soloists) if appearances.select { |a| a.solo? }.size > 1
      errors.add(:base, :cannot_have_mere_accompanists) if appearances.all? {|a| a.accompaniment? }

      # Check if there is a lonely ensemblist
      if appearances.size == 1 && appearances.all? {|a| a.ensemble? }
        errors.add(:base, :cannot_have_single_ensemblist)
      end

      # Check if one or more, but not all participants are ensemblists
      if (1...appearances.size).include? appearances.select {|a| a.ensemble? }.size
        errors.add(:base, :cannot_have_ensemblists_and_others)
      end
    end

    def appearances_empty?
      appearances.empty? || appearances.all? { |appearance| appearance.marked_for_destruction? }
    end

    def pieces_empty?
      pieces.empty? || pieces.all? { |piece| piece.marked_for_destruction? }
    end
end
