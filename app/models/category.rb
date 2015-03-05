# == Schema Information
#
# Table name: categories
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  solo         :boolean
#  ensemble     :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  popular      :boolean
#  slug         :string(255)
#  active       :boolean
#  max_round_id :integer
#

# -*- encoding : utf-8 -*-
class Category < ActiveRecord::Base
  attr_accessible :name, :solo, :ensemble, :popular, :slug, :active, :max_round_id

  # By default, show classical before pop, solo before ensemble
  default_scope order: 'popular, solo DESC, ensemble DESC, name'

  # Show only categories currently marked as active (temporary workaround)
  scope :current, where('active' => true)

  def self.classical
    where(popular: false)
  end

  def self.popular
    where(popular: true)
  end

  has_and_belongs_to_many :competitions
  belongs_to :max_round, class_name: "Round"

  validates :name, presence: true
  validates :slug, presence: true
  validates :max_round, presence: true
  # Check that either solo, ensemble or both are true – how?
end
