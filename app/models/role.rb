# -*- encoding : utf-8 -*-
# == Schema Information
# Schema version: 20110126162104
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
  attr_accessible :name, :slug
  
  has_many :appearances
end
