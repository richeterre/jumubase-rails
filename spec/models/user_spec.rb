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

require 'spec_helper'

describe User do

  let (:user) { build(:user) }

  subject { user }

  # Attributes
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:admin) }
  it { should respond_to(:host_ids) }

  # Relationships
  it { should respond_to(:hosts) }
  it { should respond_to(:contests) }

  # Convenience methods

  it { should respond_to(:admin?) }

  describe "should return whether the user is an admin" do
    before { user.admin = true }
    its(:admin?) { should be_true }
  end

  it { should respond_to(:full_name) }
  its(:full_name) { should eq "#{user.first_name} #{user.last_name}" }

  # Validations

  it { should be_valid }

  describe "without a first name" do
    before { user.first_name = "" }
    it { should_not be_valid }
  end

  describe "without a last name" do
    before { user.last_name = "" }
    it { should_not be_valid }
  end

  describe "without an email" do
    before { user.email = "" }
    it { should_not be_valid }
  end

  describe "with an email of invalid format" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]

      addresses.each do |invalid_address|
        user.email = invalid_address
        user.should_not be_valid
      end
    end
  end

  describe "with an email of valid format" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        user.email = valid_address
        user.should be_valid
      end
    end
  end

  describe "when email address already exists" do
    before do
      user_with_same_email = user.dup
      user_with_same_email.email = user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "without a password" do
    before { user.password = "" }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { user.password = user.password_confirmation = "a" * 4 }
    it { should_not be_valid }
  end
end
