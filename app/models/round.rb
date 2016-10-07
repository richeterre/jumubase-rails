# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  level      :integer
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  board_name :string(255)
#

# -*- encoding : utf-8 -*-
class Round < ActiveRecord::Base
  attr_accessible :level, :name, :slug

  has_many :contests

  validates :level, :numericality => true,
                    :inclusion => { :in => 1..3 }
  validates :name,  :presence => true
  validates :slug,  :presence => true

  def next_round_name
    next_round = Round.find_by_level(self.level + 1)
    # Return round's name if it exists
    next_round.name unless next_round.nil?
  end
end
