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
#

class Competition < ActiveRecord::Base
  attr_accessible :round_id, :host_id, :begins, :ends, :certificate_date, :category_ids

  # Finds current competitions (with matching round and end year)
  scope :current, joins(:round, :host)
      .where("rounds.level = ? AND DATE_PART('YEAR', competitions.ends) = ?", JUMU_ROUND, JUMU_YEAR)
      .order("hosts.name")

  # Finds competitions of same year, but round precedent to current
  scope :preceding, joins(:round, :host)
      .where("rounds.level = ? AND YEAR(competitions.ends) = ?", JUMU_ROUND - 1, JUMU_YEAR)
      .order("hosts.name")

  belongs_to :round
  belongs_to :host
  has_many :performances, :dependent => :destroy
  has_and_belongs_to_many :categories

  validates :round_id,  :presence => true
  validates :host_id,   :presence => true
  validates :begins,    :presence => true
  validates :ends,      :presence => true
  # Validate that the competition ends after it begins – how?

  # Virtual name that identifies the competition
  def name
    "#{self.host.name}, #{self.round.slug} #{self.ends.year}"
  end

  # Name of school hosting the competition
  def host_name
    "#{self.host.name}"
  end

  # Day range during which the competition takes place
  def days
    self.begins..self.ends
  end

  # Year in which the competition takes place
  def year
    self.ends.year
  end
end
