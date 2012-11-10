# encoding: utf-8
require 'spec_helper'

describe "Users" do

  subject { page }

  before do
    @admin = FactoryGirl.create(:admin)
    @non_admin = FactoryGirl.create(:user)
    visit root_path
  end

  describe "index page" do

    context "for non-admins" do

      before do
        sign_in(@non_admin)
        visit jmd_users_path
      end

      it "should not be accessible" do
        current_path.should eq root_path
        page.should_not have_alert_message
      end
    end

    context "for admins" do

      before do
        sign_in(@admin)
        @users = FactoryGirl.create_list(:user, 5)
        visit jmd_users_path
      end

      it "should display all existing users" do
        @users.each do |user|
          page.should have_content user.email
        end
      end

      it "should not display any other items in the list" do
        page.should have_selector "table tbody tr", count: @users.count + 2 # for login users
      end

      it "should display each user's admin status correctly" do
        page.should have_selector "tbody td", text: "Nein", count: @users.count + 1 # for login user
        page.should have_selector "tbody td", text: "Ja", count: 1 # for login admin
      end
    end
  end

  describe "create page" do

    context "for non-admins" do

      before do
        sign_in(@non_admin)
        visit new_jmd_user_path
      end

      it "should not be accessible" do
        current_path.should eq root_path
        page.should_not have_alert_message
      end
    end

    context "for admins" do

      before do
        sign_in(@admin)
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
  end

  describe "edit page" do

    before { @user = FactoryGirl.create(:user) }

    context "for non-admins" do

      before do
        sign_in(@non_admin)
        visit edit_jmd_user_path(@user)
      end

      it "should not be accessible" do
        current_path.should eq root_path
        page.should_not have_alert_message
      end
    end

    context "for admins" do

      before do
        sign_in(@admin)
        visit edit_jmd_user_path(@user)
      end

      it "should complain about invalid input"

      it "should not have a password or password confirmation field" do
        page.should_not have_content "Passwort"
        page.should_not have_content "Passwort erneut"
      end

      it "should not require a password or password confirmation" do
        fill_in "E-Mail", with: "new.address@example.org"
        click_button "Änderungen speichern"

        page.should_not have_error_message
        page.should have_success_message
      end

      it "should allow editing of the user" do
        correct_address = "correct.address@example.org"

        expect {
          fill_in "E-Mail", with: correct_address
          click_button "Änderungen speichern"
        }.to change(@user, :email).to(correct_address)
      end

      # Test this because at least earlier a hidden field was needed for this
      # (which is now removed)
      it "should allow removing all host associations at once"

      it "should allow going back to the index page without saving the changes" do
        expect {
          fill_in "E-Mail", with: "wrong.address@example.org"
          click_link "Abbrechen"
        }.to_not change(@user, :email)
        current_path.should eq jmd_users_path
      end
    end
  end
end
