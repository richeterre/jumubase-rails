# encoding: utf-8
require 'spec_helper'

describe "Appearances" do

  subject { page }

  describe "JMD" do

    before do
      @host = FactoryGirl.create(:host)
      competition = FactoryGirl.create(:current_competition, host: @host)
      @current_performances = FactoryGirl.create_list(:performance, 3, competition: competition)
    end

    let(:user) { FactoryGirl.create(:user, hosts: [@host]) }

    describe "points entry page" do

      context "when signed in as a regular user" do
        before do
          visit root_path
          sign_in(user)
          visit jmd_appearances_path
        end

        it "should list all appearances from own hosts' competitions" do
          @current_performances.each do |performance|
            page.should have_selector "tbody tr > td[rowspan='#{performance.appearances.length}']",
                                      text: performance.category.name

            performance.appearances.each do |appearance|
              page.should have_selector "tbody tr > td", text: appearance.participant.full_name
            end
          end
        end
      end

      context "when signed in as an admin"
    end
  end
end
