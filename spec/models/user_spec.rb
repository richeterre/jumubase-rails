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

require 'spec_helper'

describe User do

  let (:user) { FactoryGirl.build(:user) }

  subject { user }

  # Attributes
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:admin) }
  it { should respond_to(:host_ids) }

  # Relationships
  it { should respond_to(:hosts) }
  it { should respond_to(:competitions) }

  # Convenience methods
  it { should respond_to(:admin?) }

  it { should be_valid }

  describe "without an email" do
    before { user.email = "" }
    it { should_not be_valid }
  end

  describe "with an email of invalid format" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
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
    before { user.password = user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

  # Authentication
  describe "return value of authentication method" do
    before { user.save }
    let(:found_user) { User.find_by_email(user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
end
