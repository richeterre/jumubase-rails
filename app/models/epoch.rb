# == Schema Information
#
# Table name: epoches
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# -*- encoding : utf-8 -*-
class Epoch < ActiveRecord::Base
  attr_accessible :name, :slug
  
  has_many :pieces
  
  validates :name, :presence => true
  validates :slug, :presence => true
  
  def slug_with_name
    "#{slug}) #{name}"
  end
end
