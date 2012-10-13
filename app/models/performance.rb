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
  has_many    :appearances,   dependent: :destroy
  has_many    :participants,  through: :appearances
  has_many    :pieces,        dependent: :destroy

  accepts_nested_attributes_for :pieces,      allow_destroy: true
  accepts_nested_attributes_for :appearances, allow_destroy: true

  validates :category_id,     presence: true
  validates :competition_id,  presence: true

  validate :require_one_appearance
  validate :require_one_piece

  before_create :add_unique_tracing_code

  # Override getters to always get times in competition time zone
  def warmup_time
    super().in_time_zone(self.competition.host.time_zone) if super()
  end

  def stage_time
    super().in_time_zone(self.competition.host.time_zone) if super()
  end

  # Returns all performances in current round and year
  scope :current, where(:competition_id => Competition.current)

  # Returns all performances in given genre
  scope :is_popular, lambda { |is_popular|
    is_popular == "1" ? popular : classical
  }

  # Returns all performances in given category
  scope :in_category, lambda { |category_id| where(:category_id => category_id) }

  # Returns all performances with at least one participant from a listed country
  scope :from_countries, lambda { |countries|
    joins(:participants).
    where(:participants => { :country_id => countries }).
    group("performances.id")
  }

  # Returns all performances sent on from a given host
  scope :from_host, lambda { |host_id|
    joins(:first_competition).
    where(:competitions => { :host_id => host_id })
  }

  # Returns all performances scheduled on a given date,
  # or unscheduled if no date given
  scope :on_date, lambda { |date|
    if date.nil?
      where(:stage_time => nil)
    else
      if date.class == String
        date = Date.new(*date.split('-').map(&:to_i))
      end
      where(:stage_time => date...(date + 1.day))
    end
  }

  # Returns all performances with given venue as either warmup or stage
  scope :at_venue, lambda { |venue|
    where("warmup_venue_id = ? OR stage_venue_id = ?", venue, venue)
  }

  # Returns all performances in classical categories
  scope :classical, joins(:category).where('categories.popular = FALSE')

  # Returns all performances in pop categories
  # (using "popular" here to steer clear of Ruby #pop method)
  scope :popular, joins(:category).where('categories.popular = TRUe')

  # Orders performances chronologically by stage date
  scope :stage_order, order(:stage_time)

  # Orders performances by category default order
  scope :category_order,
      joins(:category).
      order('categories.popular, categories.solo DESC, categories.name')

  # Returns all performances the given user is authorized to see
  scope :visible_to, lambda { |user|
    if user.admin?
      scoped # Admins can see all performances
    elsif JUMU_ROUND == 1
      # Users see performances in competitions they own
      where(:competition_id => user.competitions)
    else
      # In later rounds, users see performances coming from their competitions
      where(:first_competition_id => user.competitions)
    end
  }

  def accompanists
    # Return all participants of performance that have an accompanist role
    self.appearances.with_role('B').map(&:participant)
  end

  def age_group
    # Returns age group of soloist or ensemble
    soloist = self.appearances.with_role('S').first
    if soloist.nil?
      # Just return any, as they all have the same
      self.appearances.first.age_group
    else
      soloist.age_group
    end
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
    def require_one_appearance
      errors.add(:base, :needs_one_appearance) if appearances_empty?
    end

    def require_one_piece
      errors.add(:base, :needs_one_piece) if pieces_empty?
    end

    def appearances_empty?
      appearances.empty? || appearances.all? { |appearance| appearance.marked_for_destruction? }
    end

    def pieces_empty?
      pieces.empty? || pieces.all? { |piece| piece.marked_for_destruction? }
    end

    def add_unique_tracing_code
      begin
        # Generates a random string of seven lowercase letters and numbers
        code = [('a'..'z'), (0..9)].map{ |i| i.to_a }.flatten.shuffle[0..6].join
      end while Performance.where(:tracing_code => code).exists?

      self.tracing_code = code
    end
end
