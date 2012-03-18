# == Schema Information
# Schema version: 20110228140044
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  username           :string(255)
#  encrypted_password :string(255)
#  admin              :boolean(1)
#  salt               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  attr_accessible :username, :password, :password_confirmation, :admin, :host_ids
  has_secure_password # Enable authentication
    
  has_and_belongs_to_many :hosts
  has_many :competitions, :through => :hosts
  
  validates :username,  :presence => true,
                        :length => { :maximum => 30 },
                        :uniqueness => true
  
  def admin?
    self.admin
  end
  
  def competitions
    # Admins can access all competitions
    self.admin? ? Competition.scoped : super()
  end
end
