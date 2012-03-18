# == Schema Information
# Schema version: 20110301203607
#
# Table name: venues
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  host_id    :integer(4)
#  address    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# -*- encoding : utf-8 -*-
class Venue < ActiveRecord::Base
  attr_accessible :name, :slug, :host_id, :address
  
  belongs_to :host
  
  validates :name,    :presence => true
  validates :slug,    :presence => true,
                      :length => { :maximum => 3 },
                      :uniqueness => true
  validates :host_id, :presence => true
  validates :address, :presence => true
end
