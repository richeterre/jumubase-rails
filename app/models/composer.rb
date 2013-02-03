# == Schema Information
#
# Table name: composers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  born       :string(255)
#  died       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  piece_id   :integer
#

# -*- encoding : utf-8 -*-
class Composer < ActiveRecord::Base
  attr_accessible :piece_id, :name, :born, :died

  belongs_to :piece # otherwise editing a piece's composer corrupts other pieces

  validates :name,      presence: true
end
