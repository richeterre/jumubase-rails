# == Schema Information
#
# Table name: contest_categories
#
#  id          :integer          not null, primary key
#  contest_id  :integer          not null
#  category_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ContestCategory < ActiveRecord::Base
  attr_accessible :contest_id, :category_id

  belongs_to :contest
  belongs_to :category
  has_many :performances, dependent: :destroy

  validates :contest_id, presence: true
  validates :category_id, presence: true

  def name
    category.name
  end
end
