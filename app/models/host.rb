# == Schema Information
#
# Table name: hosts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  city       :string(255)
#  time_zone  :string(255)      default("Europe/Berlin")
#

# -*- encoding : utf-8 -*-
class Host < ActiveRecord::Base
  attr_accessible :name, :city, :country_id, :time_zone

  belongs_to :country
  has_many :competitions
  has_many :venues

  validates :name,        presence: true
  validates :city,        presence: true
  validates :country_id,  presence: true

  def time_zone
    ActiveSupport::TimeZone.new(super()) if super()
  end
end
