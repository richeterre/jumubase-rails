# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)
#  encrypted_password :string(255)
#  admin              :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  salt               :string(255)
#  password_digest    :string(255)
#  last_login         :datetime
#  remember_token     :string(255)
#

# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :admin, :host_ids
  has_secure_password # Enable authentication

  has_and_belongs_to_many :hosts
  has_many :competitions, through: :hosts

  before_save { |user| user.email = user.email.downcase }
  before_create :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,                 presence: true,
                                    format: { with: VALID_EMAIL_REGEX },
                                    uniqueness: { case_sensitive: false }
  validates :password,              presence: true,
                                    length: { minimum: 5 },
                                    on: :create
  validates :password,              length: { minimum: 5 },
                                    on: :update,
                                    unless: lambda { |user| user.password.blank? }



  def admin?
    self.admin
  end

  def competitions
    # Admins can access all competitions
    self.admin? ? Competition.scoped : super()
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
