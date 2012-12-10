# == Schema Information
#
# Table name: pieces
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  composer_id    :integer
#  performance_id :integer
#  epoch_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  minutes        :integer
#  seconds        :integer
#

# -*- encoding : utf-8 -*-
class Piece < ActiveRecord::Base
  attr_accessible :title, :composer_id, :performance_id, :epoch_id, :minutes, :seconds,
      :composer_attributes

  belongs_to :composer, dependent: :destroy # since every piece has its own composer
  belongs_to :performance, touch: true
  belongs_to :epoch

  accepts_nested_attributes_for :composer

  # These do not currently play nicely with accept_nested_attributes
  # validates :composer_id,  presence: true
  # validates :performance_id,  presence: true

  validates :title,           presence: true
  validates :epoch_id,        presence: true
  validates :minutes,         presence: true,
                              numericality: {
                                only_integer: true,
                                greater_than_or_equal_to: 0,
                                less_than: 60
                              }
  validates :seconds,         presence: true,
                              numericality: {
                                only_integer: true,
                                greater_than_or_equal_to: 0,
                                less_than: 60
                              }

  def duration
    minutes*60 + seconds
  end
end
