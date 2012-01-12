# -*- encoding : utf-8 -*-
# == Schema Information
# Schema version: 20110126162104
#
# Table name: countries
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Country < ActiveRecord::Base
  attr_accessible :name, :slug
  
  has_many :hosts
  has_many :judges
  has_many :participants
  
  validates :name, :presence => true
  validates :slug, :presence => true
end
