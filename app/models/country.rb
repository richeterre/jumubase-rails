# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# -*- encoding : utf-8 -*-
class Country < ActiveRecord::Base
  attr_accessible :name, :slug
  
  has_many :hosts
  has_many :participants
  has_and_belongs_to_many :users
  
  validates :name, :presence => true
  validates :slug, :presence => true
end
