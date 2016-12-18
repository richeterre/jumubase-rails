# == Schema Information
#
# Table name: categories
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  solo                   :boolean
#  ensemble               :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  slug                   :string(255)
#  official_min_age_group :string(255)      default("Ia")
#  official_max_age_group :string(255)      default("VII")
#  max_round              :integer
#  genre                  :string(255)
#

# -*- encoding : utf-8 -*-
class Category < ActiveRecord::Base
  attr_accessible :name, :solo, :ensemble, :popular, :slug,
    :max_round, :official_min_age_group, :official_max_age_group

  # Define default sorting order for categories
  default_scope order: 'genre, solo DESC, ensemble DESC, name'

  has_many :contest_categories, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true
  validates :max_round,
    presence: true,
    inclusion: { in: 1..3 }
  validates :official_min_age_group, presence: true,
                                     inclusion: { :in => JUMU_AGE_GROUPS }
  validates :official_max_age_group, presence: true,
                                     inclusion: { :in => JUMU_AGE_GROUPS }
  # Check that either solo, ensemble or both are true – how?

  def popular?
    self.genre == 'popular'
  end
end
