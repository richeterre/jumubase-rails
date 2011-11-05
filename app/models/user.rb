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
  attr_accessor :password
  attr_accessible :username, :password, :password_confirmation
  
  has_and_belongs_to_many :hosts
  
  validates :username,  :presence => true,
                        :length => { :maximum => 30 },
                        :uniqueness => true
  validates :password,  :presence => true,
                        :confirmation => true,
                        :length => { :within => 5..30 }
  
  before_save :encrypt_password
  
  def admin?
    self.admin
  end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(username, submitted_password)
    user = find_by_username(username)
    user && user.has_password?(submitted_password) ? user : nil
  end
  
  def self.authenticate_with_salt(id, session_salt)
    user = find_by_id(id)
    (user && user.salt == session_salt) ? user : nil
  end
  
  private # Applies to all methods defined below this
    
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
