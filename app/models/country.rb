# == Schema Information
#
# Table name: countries
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  slug         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  country_code :string(255)
#

# -*- encoding : utf-8 -*-
class Country < ActiveRecord::Base
  attr_accessible :name, :slug, :country_code

  has_many :hosts
  has_many :participants

  validates :name,         presence: true
  validates :slug,         presence: true
  validates :country_code, presence: true
end
