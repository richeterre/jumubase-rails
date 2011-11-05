# == Schema Information
# Schema version: 20110305104946
#
# Table name: pieces
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  composer_id :integer(4)
#  entry_id    :integer(4)
#  epoch_id    :integer(4)
#  duration    :string(255)
#  minutes     :integer(4)
#  seconds     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

# -*- encoding : utf-8 -*-
class Piece < ActiveRecord::Base
  attr_accessible :title, :composer_id, :entry_id, :epoch_id, :minutes, :seconds,
      :composer_attributes
  
  belongs_to :composer, :dependent => :destroy # since every piece has its own composer
  belongs_to :entry, :touch => true
  belongs_to :epoch
  
  accepts_nested_attributes_for :composer
  
  validates :title,       :presence => true
  validates :epoch_id,    :presence => true
  validates :minutes,     :presence => true,
                          :numericality => true,
                          :inclusion => { :in => 0..45 }
  validates :seconds,     :presence => true,
                          :numericality => true,
                          :inclusion => { :in => 0..59 }
                          
  def duration
    min = (minutes || 0)
    sec = (seconds || 0)
    min*60 + sec
  end
end
