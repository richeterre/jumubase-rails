# encoding: utf-8
require 'spec_helper'

describe "Signup page" do

  subject { page }

  describe "for the first round" do

    before do
      FactoryGirl.create_list(:old_competition, 3)
      FactoryGirl.create_list(:future_competition, 3)
      @current_competitions = FactoryGirl.create_list(:current_competition, 3)

      FactoryGirl.create_list(:category, 3)
      @active_categories = FactoryGirl.create_list(:active_category, 3)

      visit new_performance_path
    end

    it { should have_select "Wettbewerb", options: ["Bitte wählen"] + @current_competitions.map(&:name) }
    it { should have_select "Kategorie", options: ["Bitte wählen"] + @active_categories.map(&:name) }

    it "should allow only valid inputs for the minutes and seconds fields" do
      pending "These columns need to be made numerical for better SimpleForm integration"
    end
  end

  describe "for the second round" do

    it "should pre-select the competition for the user" do
      pending "Check that the competition selector is already set for the user"
    end

    it "should already know where the first round was performed" do
      pending "Or even better, don't require this form at all"
    end
  end
end