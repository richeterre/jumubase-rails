# -*- encoding : utf-8 -*-
# == Schema Information
# Schema version: 20110126162104
#
# Table name: competitions
#
#  id         :integer(4)      not null, primary key
#  round_id   :integer(4)
#  host_id    :integer(4)
#  begins     :date
#  ends       :date
#  created_at :datetime
#  updated_at :datetime
#

class Competition < ActiveRecord::Base
  attr_accessible :round_id, :host_id, :begins, :ends, :category_ids
  
  # Finds current competitions (with matching round and end year)
  scope :current, joins(:round, :host)
      .where("rounds.level = ? AND YEAR(competitions.ends) = ?", JUMU_ROUND, JUMU_YEAR)
      .order("hosts.name")
      
  # Finds competitions of same year, but round precedent to current
  scope :preceding, joins(:round, :host)
      .where("rounds.level = ? AND YEAR(competitions.ends) = ?", JUMU_ROUND - 1, JUMU_YEAR)
      .order("hosts.name")
  
  belongs_to :round
  belongs_to :host
  has_many :entries, :dependent => :destroy
  has_and_belongs_to_many :categories
  
  validates :round_id,  :presence => true
  validates :host_id,   :presence => true
  validates :begins,    :presence => true
  validates :ends,      :presence => true
  # Validate that the competition ends after it begins – how?
  
  # Virtual name that identifies the competition
  def name
    "#{self.host.name}, #{self.round.slug} #{self.begins.year}"
  end
  
  def host_name
    "#{self.host.name}"
  end
end
