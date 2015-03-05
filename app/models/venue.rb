class Venue < ActiveRecord::Base
  attr_accessible :host_id, :name

  belongs_to :host

  validates :name, presence: true
  validates :host_id, presence: true
end
