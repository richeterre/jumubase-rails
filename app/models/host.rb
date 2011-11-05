# -*- encoding : utf-8 -*-
# == Schema Information
# Schema version: 20110126162104
#
# Table name: hosts
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  country_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Host < ActiveRecord::Base
  attr_accessible :name, :country_id
  
  belongs_to :country
  has_many :competitions
  has_many :venues
  
  validates :name,        :presence => true
  validates :country_id,  :presence => true
end
