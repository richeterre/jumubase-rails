# encoding: utf-8
require 'spec_helper'

describe "Contests" do

  subject { page }

  before do
    @host = create(:host)
    @non_admin = create(:user, hosts: [@host])
    @admin = create(:admin)
    visit root_path
  end

  describe "index page" do

    before do
      # Contests the user may see
      @current_contest = create(:current_contest, host: @host)
      @future_contest = create(:future_contest, host: @host)
      @past_contest = create(:past_contest, host: @host)

      @other_contest = create(:contest, host: create(:host))
    end

    context "for non-admins" do
      before do
        sign_in(@non_admin)
        visit jmd_contests_path
      end

      it "should list the contests in chronological order, earliest first" do
        page.should have_selector "table tbody tr:first-child", text: @past_contest.name
        page.should have_selector "table tbody tr:nth-last-child(2)", text: @current_contest.name
        page.should have_selector "table tbody tr:last-child", text: @future_contest.name
      end

      it "should not list contests from hosts the user is not associated with" do
        page.should_not have_content @other_contest.name
      end
    end

    context "for admins" do

      before do
        sign_in(@admin)
        visit jmd_contests_path
      end

      it "should display all existing contests" do
        Contest.all.each do |contest|
          page.should have_content contest.name
        end
      end

      it "should not display any other items in the list" do
        page.should have_selector "table tbody tr", count: Contest.count
      end
    end
  end

  describe "create page" do

    context "for non-admins" do
      before do
        sign_in(@non_admin)
        visit new_jmd_contest_path
      end

      it "should not be accessible" do
        current_path.should eq new_user_session_path
        page.should have_alert_message
      end
    end

    context "for admins" do
      before do
        sign_in(@admin)
        visit new_jmd_contest_path
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
        }.to_not change(Contest, :count)
        current_path.should eq jmd_contests_path
      end
    end
  end

  describe "edit page" do

    before { @contest = create(:contest) }

    context "for non-admins" do
      before do
        sign_in(@non_admin)
        visit edit_jmd_contest_path(@contest)
      end

      it "should not be accessible" do
        current_path.should eq new_user_session_path
        page.should have_alert_message
      end
    end

    context "for admins" do
      before do
        sign_in(@admin)
        visit edit_jmd_contest_path(@contest)
      end

      it "should complain about invalid input" do
        fill_in "Saison", with: ""
        click_button "Änderungen speichern"

        page.should have_error_message
        page.should have_content "Saison muss ausgefüllt werden"
        page.should have_content "Saison ist keine Zahl"
      end

      it "should allow editing of the contest" do
        correct_season = @contest.season + 1

        fill_in "Saison", with: correct_season
        click_button "Änderungen speichern"

        current_path.should eq jmd_contests_path
        page.should have_success_message
        page.should have_selector "tbody td", text: correct_season.to_s
      end

      # Test this because at least earlier a hidden field was needed for this
      # (which is now removed)
      it "should allow removing all categories at once"

      it "should allow going back to the index page without saving the changes" do
        wrong_season = @contest.season + 0.5

        expect {
          fill_in "Saison", with: wrong_season
          click_link "Abbrechen"
        }.to_not change(@contest, :season)
        current_path.should eq jmd_contests_path
      end
    end
  end

  describe "show page" do
    before do
      @contest = create(:contest, host: @host)
    end

    context "for non-admins" do
      before do
        visit root_path
        sign_in(@non_admin)
        visit jmd_contest_path(@contest)
      end

      specify { current_path.should eq jmd_contest_path(@contest) }

      it { should_not have_link "Weiterleitungen migrieren",
                                href: list_advancing_jmd_contest_path(@contest) }
    end

    context "for admins" do
      before do
        visit root_path
        sign_in(@admin)
        visit jmd_contest_path(@contest)
      end

      it { should have_link "Weiterleitungen migrieren",
                                href: list_advancing_jmd_contest_path(@contest) }
    end
  end

  describe "migration page for advancing performances" do
    before do
      @contest = create(:contest, host: @host)
    end

    context "for non-admins" do
      it "should not be accessible" do
        visit root_path
        sign_in(@non_admin)
        visit list_advancing_jmd_contest_path(@contest)

        current_path.should eq new_user_session_path
        page.should have_alert_message
      end
    end

    context "for admins" do
      before do
        next_round = @contest.round + 1
        create(:contest, round: @contest.round) # to test for correct exclusion
        @next_contests = create_list(:contest, 3, round: next_round)

        visit root_path
        sign_in(@admin)
        visit list_advancing_jmd_contest_path(@contest)
      end

      it "should have the correct target contest candidates to choose from" do
        page.should have_select "_target_contest_id", options: @next_contests.map(&:name)
      end

      it { should have_button "migrieren" }
    end
  end
end
