# == Schema Information
#
# Table name: pieces
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  performance_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  minutes        :integer
#  seconds        :integer
#  composer_name  :string(255)
#  composer_born  :string(255)
#  composer_died  :string(255)
#  epoch          :string(255)
#

# -*- encoding : utf-8 -*-
class Piece < ActiveRecord::Base
  attr_accessible :title, :performance_id, :epoch, :minutes, :seconds, :composer_name, :composer_born, :composer_died

  amoeba do
    enable # Allow deep duplication
  end

  belongs_to :performance, touch: true

  # This does not currently play nicely with accept_nested_attributes
  # validates :performance_id,  presence: true

  validates :title, presence: true
  validates :epoch,
    presence: true,
    inclusion: { in: JUMU_EPOCHS }
  validates :minutes,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than: 60
    }
  validates :seconds,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than: 60
    }
  validates :composer_name, presence: true

  def duration
    minutes*60 + seconds
  end
end
