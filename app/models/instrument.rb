# -*- encoding : utf-8 -*-
# == Schema Information
# Schema version: 20110126162104
#
# Table name: instruments
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Instrument < ActiveRecord::Base
  attr_accessible :name
  
  has_many :appearances
  
  validates :name, :presence => true
end
