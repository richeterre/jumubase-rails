# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  admin                  :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string(255)
#  last_name              :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#

# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
    :validatable, password_length: 6..128

  # Setup accessible (or protected) attributes for your model
  attr_accessible :admin, :email, :first_name, :host_ids, :last_name,
    :password, :password_confirmation, :remember_me

  has_and_belongs_to_many :hosts
  has_many :contests, through: :hosts

  before_save { |user| user.email = user.email.downcase }

  validates :first_name,  presence: true
  validates :last_name,   presence: true

  def admin?
    self.admin
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def contests
    # Admins can access all contests
    self.admin? ? Contest.scoped : super()
  end
end
