# encoding: utf-8
require 'spec_helper'

describe "Users" do

  subject { page }

  before do
    admin = FactoryGirl.create(:admin)
    visit root_path
    sign_in(admin)
  end

  describe "index page" do

    before do
      @users = FactoryGirl.create_list(:user, 5)
      visit jmd_users_path
    end

    it "should display all existing users" do
      @users.each do |user|
        page.should have_content user.email
      end
    end

    it "should not display any other items in the list" do
      page.should have_selector "table tbody tr", count: @users.count + 1 # for admin
    end

    it "should display each user's admin status correctly" do
      page.should have_selector "tbody td", text: "Nein", count: @users.count
      page.should have_selector "tbody td", text: "Ja", count: 1
    end
  end

  describe "create page" do

    before do
      visit new_jmd_user_path
    end

    it "should complain about invalid input"

    it "should allow creating a new user"

    it "should allow going back to the index page without creating anything" do
      expect {
        click_link "Abbrechen"
      }.to_not change(User, :count)
      current_path.should eq jmd_users_path
    end
  end

  describe "edit page" do
    before do
      @user = FactoryGirl.create(:user)
      visit edit_jmd_user_path(@user)
    end

    it "should complain about invalid input"

    it "should allow editing of the user"

    it "should allow going back to the index page without saving the changes" do
      expect {
        click_link "Abbrechen"
      }.to_not change(@user)
      current_path.should eq jmd_users_path
    end
  end
end
