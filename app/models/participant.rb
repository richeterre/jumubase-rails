# == Schema Information
#
# Table name: participants
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  birthdate  :date
#  phone      :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# -*- encoding : utf-8 -*-
class Participant < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :birthdate, :phone, :email

  has_many :appearances,  dependent: :destroy
  has_many :performances, through: :appearances

  comma do
    id
    first_name
    last_name
    birthdate
    phone
    email
    appearances do |appearances|
      appearances.map(&:instrument).map(&:name).uniq.join(", ")
    end
  end

  after_save :resave_performances # since their age group might have changed

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :first_name,  presence: true
  validates :last_name,   presence: true
  validates :birthdate,   presence: true
  validates :phone,       presence: true
  validates :email,       presence: true,
                          format: { with: email_regex }

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  private

    def resave_performances
      self.performances.each do |performance|
        performance.save
      end
    end
end
