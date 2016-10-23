# == Schema Information
#
# Table name: contests
#
#  id                :integer          not null, primary key
#  round_id          :integer
#  host_id           :integer
#  begins            :date
#  ends              :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  certificate_date  :date
#  season            :integer
#  signup_deadline   :date
#  timetables_public :boolean          default(FALSE)
#

class Contest < ActiveRecord::Base
  attr_accessible :season, :round_id, :host_id, :begins, :ends, :signup_deadline,
                  :certificate_date, :timetables_public

  belongs_to :round
  belongs_to :host
  has_many :contest_categories, dependent: :destroy
  has_many :performances, through: :contest_categories
  has_many :appearances, through: :performances, readonly: true
  has_many :participants, through: :appearances, uniq: true, readonly: true
  has_many :venues, through: :host, readonly: true

  validates :season,          presence: true,
                              numericality: { only_integer: true, greater_than: 0 }
  validates :round_id,        presence: true
  validates :host_id,         presence: true
  validates :begins,          presence: true
  validates :ends,            presence: true
  validates :signup_deadline, presence: true

  # Validate order of associated dates, if available (presence is validated separately)
  validate :require_beginning_before_end
  validate :require_signup_deadline_before_beginning

  # Find contests with given round level
  def self.with_level(level)
    joins(:round)
    .where(rounds: { level: level })
  end

  # Find contests of this season with given round level
  def self.seasonal_with_level(level)
    joins(:round)
    .where(season: JUMU_SEASON, rounds: { level: level })
  end

  # Find contests with season and round currently set in JUMU_PARAMS
  def self.current
    seasonal_with_level(JUMU_ROUND)
    .joins(:host)
    .order("hosts.name")
  end

  # Find contests with timetables public or not, depending on value
  def self.with_timetables_public(value)
    where(timetables_public: value)
  end

  # Find contests whose signup is open
  def self.open
    where("contests.signup_deadline >= ?", today_for_signup)
  end

  # Find contests one round earlier than the current
  def self.preceding
    joins(:round, :host)
    .where(season: JUMU_SEASON, rounds: { level: JUMU_ROUND - 1 })
    .order("hosts.name")
  end

  # Find venues that are used in this contest
  def used_venues
    venues.joins(performances: :contest_category)
      .where("performances.stage_time IS NOT NULL AND contest_categories.contest_id = ?", self.id)
      .uniq
  end

  # Find performances for a given venue and date
  def staged_performances(venue, date)
    performances.where("performances.stage_time IS NOT NULL")
                .stage_order
                .on_date(date)
                .at_stage_venue(venue.id)
  end

  # Virtual name that identifies the contest
  def name
    "#{self.host.name}, #{self.round.slug} #{self.year}"
  end

  # Name of school hosting the contest
  def host_name
    "#{self.host.name}"
  end

  # Day range during which the contest takes place
  def days
    self.begins..self.ends
  end

  # Season (not necessarily calendar) year of this contest
  def year
    JUMU_YEAR + self.season - JUMU_SEASON
  end

  # Full round name and year
  def round_name_and_year
    "#{self.round.name} #{self.year}"
  end

  # Short round name and year
  def round_slug_and_year
    "#{self.round.slug} #{self.year}"
  end

  # Whether the signup deadline has passed
  def signup_deadline_passed?
    return self.signup_deadline < self.class.today_for_signup
  end

  # Whether participants can advance to this contest
  def can_be_advanced_to?
    self.round.level > 1
  end

  # Whether participants can advance onwards from this contest
  def can_be_advanced_from?
    self.round.level < 2 # Currently no LW > BW migration is possible
  end

  # Find contests of the same season that are one round lower
  def possible_predecessors
    Contest.joins(:round, :host)
               .where({ rounds: { level: self.round.level - 1 }, season: self.season })
               .order("hosts.name")
  end

  # Find contests of the same season that are one round higher
  def possible_successors
    Contest.joins(:round, :host)
               .where({ rounds: { level: self.round.level + 1 }, season: self.season })
               .order("hosts.name")
  end

  private

    # Returns a "today" date used for signup deadline comparisons
    def self.today_for_signup
      # Assume that all hosts are either on or ahead of UTC time.
      # This prevents contests from closing prematurely in their countries.
      return Time.now.utc.to_date
    end

    def require_beginning_before_end
      unless begins.nil? || ends.nil?
        errors.add(:base, :beginning_not_before_end) if ends < begins
      end
    end

    def require_signup_deadline_before_beginning
      unless begins.nil? || signup_deadline.nil?
        errors.add(:base, :signup_deadline_not_before_beginning) unless signup_deadline < begins
      end
    end
end
