# == Schema Information
#
# Table name: competitions
#
#  id               :integer          not null, primary key
#  round_id         :integer
#  host_id          :integer
#  begins           :date
#  ends             :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  certificate_date :date
#  season           :integer
#  signup_deadline  :datetime
#

class Competition < ActiveRecord::Base
  attr_accessible :season, :round_id, :host_id, :begins, :ends, :signup_deadline,
                  :certificate_date, :category_ids

  # Finds current competitions (with matching round and end year)
  scope :current, joins(:round, :host)
      .where("rounds.level = ? AND competitions.season = ?", JUMU_ROUND, JUMU_SEASON)
      .order("hosts.name")

  # Finds current competitions whose signup is open
  scope :current_and_open, lambda {
    now = Time.now
    current.where("competitions.signup_deadline > ?", now)
  }

  # Finds competitions of same year, but round precedent to current
  scope :preceding, joins(:round, :host)
      .where("rounds.level = ? AND competitions.season = ?", JUMU_ROUND - 1, JUMU_SEASON)
      .order("hosts.name")

  belongs_to :round
  belongs_to :host
  has_many :performances, :dependent => :destroy
  has_and_belongs_to_many :categories

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

  # Virtual name that identifies the competition
  def name
    "#{self.host.name}, #{self.round.slug} #{self.year}"
  end

  # Name of school hosting the competition
  def host_name
    "#{self.host.name}"
  end

  # Last full day of signup
  def last_signup_date
    self.signup_deadline.to_date - 1.day
  end

  # Day range during which the competition takes place
  def days
    self.begins..self.ends
  end

  # Season (not necessarily calendar) year of this competition
  def year
    JUMU_YEAR + self.season - JUMU_SEASON
  end

  private

    def require_beginning_before_end
      unless begins.nil? || ends.nil?
        errors.add(:base, :beginning_not_before_end) if ends < begins
      end
    end

    def require_signup_deadline_before_beginning
      unless begins.nil? || signup_deadline.nil?
        errors.add(:base, :signup_deadline_not_before_beginning) unless signup_deadline < begins.to_time
      end
    end
end
