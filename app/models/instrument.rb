# == Schema Information
#
# Table name: instruments
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# -*- encoding : utf-8 -*-
class Instrument < ActiveRecord::Base
  attr_accessible :name
  
  has_many :appearances
  
  validates :name, :presence => true
end
