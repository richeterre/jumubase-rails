# == Schema Information
#
# Table name: participants
#
#  id          :integer          not null, primary key
#  first_name  :string(255)
#  last_name   :string(255)
#  gender      :string(255)
#  birthdate   :date
#  street      :string(255)
#  postal_code :string(255)
#  city        :string(255)
#  country_id  :integer
#  phone       :string(255)
#  email       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# -*- encoding : utf-8 -*-
class Participant < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :gender, :birthdate,
      :street, :postal_code, :city, :country_id, :phone, :email
  
  belongs_to :country
  has_many :appearances,  :dependent => :destroy
  has_many :entries,      :through => :appearances
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :first_name,  :presence => true
  validates :last_name,   :presence => true
  validates :gender,      :presence => true,
                          :inclusion => { :in => ["m", "f"] }
  validates :birthdate,   :presence => true
  validates :country_id,  :presence => true
  validates :phone,       :presence => true
  validates :email,       :presence => true,
                          :format => { :with => email_regex }

  # Virtual full name of participant
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
