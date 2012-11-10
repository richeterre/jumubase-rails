# encoding: utf-8
require 'spec_helper'

describe "Competitions" do

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
        visit jmd_competitions_path
      end

      it "should not be accessible" do
        current_path.should eq root_path
        page.should_not have_alert_message
      end
    end

    context "for admins" do
      before do
        sign_in(@admin)
        @competitions = FactoryGirl.create_list(:competition, 5)
        visit jmd_competitions_path
      end

      it "should display all existing competitions" do
        @competitions.each do |competition|
          page.should have_content competition.name
        end
      end

      it "should not display any other items in the list" do
        page.should have_selector "table tbody tr", count: @competitions.count
      end
    end
  end

  describe "create page" do

    context "for non-admins" do
      before do
        sign_in(@non_admin)
        visit new_jmd_competition_path
      end

      it "should not be accessible" do
        current_path.should eq root_path
        page.should_not have_alert_message
      end
    end

    context "for admins" do
      before do
        sign_in(@admin)
        visit new_jmd_competition_path
      end

      it "should complain about invalid input"

      it "should allow creating a new user"

      it "should allow going back to the index page without creating anything" do
        expect {
          click_link "Abbrechen"
        }.to_not change(Competition, :count)
        current_path.should eq jmd_competitions_path
      end
    end
  end

  describe "edit page" do

    before { @competition = FactoryGirl.create(:competition) }

    context "for non-admins" do
      before do
        sign_in(@non_admin)
        visit edit_jmd_competition_path(@competition)
      end

      it "should not be accessible" do
        current_path.should eq root_path
        page.should_not have_alert_message
      end
    end

    context "for admins" do
      before do
        sign_in(@admin)
        visit edit_jmd_competition_path(@competition)
      end

      it "should complain about invalid input"

      it "should allow editing of the competition" do
        correct_season = @competition.season + 1
        expect {
          fill_in "Saison", with: correct_season
          click_button "Änderungen speichern"
        }.to change(@competition, :season).to(correct_season)

        page.should have_success_message
      end

      # Test this because at least earlier a hidden field was needed for this
      # (which is now removed)
      it "should allow removing all categories at once"

      it "should allow going back to the index page without saving the changes" do
        wrong_season = @competition.season + 0.5

        expect {
          fill_in "Saison", with: wrong_season
          click_link "Abbrechen"
        }.to_not change(@competition, :season)
        current_path.should eq jmd_competitions_path
      end
    end
  end
end
