# -*- encoding : utf-8 -*-
# == Schema Information
# Schema version: 20110126162104
#
# Table name: epoches
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Epoch < ActiveRecord::Base
  attr_accessible :name, :slug
  
  has_many :pieces
  
  validates :name, :presence => true
  validates :slug, :presence => true
  
  def slug_with_name
    "#{slug}) #{name}"
  end
end
