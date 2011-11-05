# == Schema Information
# Schema version: 20110313012904
#
# Table name: categories
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  solo       :boolean(1)
#  ensemble   :boolean(1)
#  pop        :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

# -*- encoding : utf-8 -*-
class Category < ActiveRecord::Base
  attr_accessible :name, :solo, :ensemble, :pop
  
  # By default, show classical before pop, solo before ensemble
  default_scope :order => 'pop, solo DESC, name'
  
  has_many :entries
  has_and_belongs_to_many :competitions
  
  validates :name, :presence => true
  # Check that either solo, ensemble or both are true – how?
end
