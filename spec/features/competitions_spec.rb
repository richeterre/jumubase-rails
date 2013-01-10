# encoding: utf-8
require 'spec_helper'

describe "Competitions" do

  subject { page }

  before do
    @host = FactoryGirl.create(:host)
    @non_admin = FactoryGirl.create(:user, hosts: [@host])
    @admin = FactoryGirl.create(:admin)
    visit root_path
  end

  describe "index page" do

    before do
      # Competitions the user may see
      @current_competition = FactoryGirl.create(:current_competition, host: @host)
      @future_competition = FactoryGirl.create(:future_competition, host: @host)
      @past_competition = FactoryGirl.create(:past_competition, host: @host)

      @other_competition = FactoryGirl.create(:competition, host: FactoryGirl.create(:host))
    end

    context "for non-admins" do
      before do
        sign_in(@non_admin)
        visit jmd_competitions_path
      end

      it "should list the competitions in chronological order, earliest first" do
        page.should have_selector "table tbody tr:first-child", text: @past_competition.name
        page.should have_selector "table tbody tr:nth-last-child(2)", text: @current_competition.name
        page.should have_selector "table tbody tr:last-child", text: @future_competition.name
      end

      it "should not list competitions from hosts the user is not associated with" do
        page.should_not have_content @other_competition.name
      end
    end

    context "for admins" do

      before do
        sign_in(@admin)
        visit jmd_competitions_path
      end

      it "should display all existing competitions" do
        Competition.all.each do |competition|
          page.should have_content competition.name
        end
      end

      it "should not display any other items in the list" do
        page.should have_selector "table tbody tr", count: Competition.count
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
        current_path.should eq signin_path
        page.should have_alert_message
      end
    end

    context "for admins" do
      before do
        sign_in(@admin)
        visit new_jmd_competition_path
      end

      it "should have all required form fields"

      it "should complain about invalid input" do
        click_button "Wettbewerb erstellen"

        page.should have_error_message
        page.should have_content "Saison muss ausgefüllt werden"
        page.should have_content "Saison ist keine Zahl"
        page.should have_content "Runde muss ausgefüllt werden"
        page.should have_content "Schule muss ausgefüllt werden"
        page.should have_content "Beginn muss ausgefüllt werden"
        page.should have_content "Ende muss ausgefüllt werden"
        page.should have_content "Anmeldeschluss muss ausgefüllt werden"
      end

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
        current_path.should eq signin_path
        page.should have_alert_message
      end
    end

    context "for admins" do
      before do
        sign_in(@admin)
        visit edit_jmd_competition_path(@competition)
      end

      it "should complain about invalid input" do
        fill_in "Saison", with: ""
        click_button "Änderungen speichern"

        page.should have_error_message
        page.should have_content "Saison muss ausgefüllt werden"
        page.should have_content "Saison ist keine Zahl"
      end

      it "should allow editing of the competition" do
        correct_season = @competition.season + 1

        fill_in "Saison", with: correct_season
        click_button "Änderungen speichern"

        current_path.should eq jmd_competitions_path
        page.should have_success_message
        page.should have_selector "tbody td", text: correct_season.to_s
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
