# -*- encoding : utf-8 -*-
# == Schema Information
# Schema version: 20110126162104
#
# Table name: composers
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  born       :string(255)
#  died       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Composer < ActiveRecord::Base
  attr_accessible :name, :born, :died
  
  has_one :piece # otherwise editing a piece's composer leads to conflicts
  
  validates :name, :presence => true
  # Validate that the composer died after his/her birth – how?
end
