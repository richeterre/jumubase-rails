# -*- encoding : utf-8 -*-
# == Schema Information
# Schema version: 20110126162104
#
# Table name: rounds
#
#  id         :integer(4)      not null, primary key
#  level      :integer(4)
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Round < ActiveRecord::Base
  attr_accessible :level, :name, :slug
  
  has_many :competitions
  
  validates :level, :numericality => true,
                    :inclusion => { :in => 1..3 }
  validates :name,  :presence => true
  validates :slug,  :presence => true
end
