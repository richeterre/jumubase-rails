# == Schema Information
#
# Table name: venues
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  host_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Venue < ActiveRecord::Base
  attr_accessible :host_id, :name

  belongs_to :host

  validates :name, presence: true
  validates :host_id, presence: true
end
