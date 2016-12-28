# encoding: utf-8
require 'spec_helper'

describe "Appearances" do

  subject { page }

  describe "JMD" do

    before do
      @host = create(:host)
      contest = create(:current_contest, host: @host)
      contest_category = create(:contest_category, contest: contest)
      create_list(:performance, 3, contest_category: contest_category)
      create_list(:current_solo_acc_performance, 3, contest_category: contest_category)
      create_list(:current_ensemble_performance, 3, contest_category: contest_category)
    end

    let(:user) { create(:user, hosts: [@host]) }

    describe "points entry page" do

      context "when signed in as a regular user" do
        before do
          visit root_path
          click_on "Interne Seiten"
          sign_in(user)
          visit jmd_appearances_path
        end

        it "should list all appearances from own hosts' contests" do
          Performance.all.each do |performance|
            page.should have_selector "tbody tr > td[rowspan='#{performance.appearances.length}']",
                                      text: performance.category.name

            performance.appearances.each do |appearance|
              page.should have_selector "tbody tr",
                                        text: "#{appearance.participant.full_name}, #{appearance.instrument.name}"
              page.should have_selector "tbody tr > td > span.badge-info",
                                        text: appearance.age_group
            end
          end
        end

        it "should allow editing an appearance's points", js: true do
          appearance = Performance.first.appearances.first

          modal_id = "#appearance#{appearance.id}Modal"
          find(:xpath, "//a[@href='#{modal_id}']").click

          within(modal_id) do
            fill_in "Punktzahl", with: 23
            click_button "Punkte speichern"
          end

          page.should have_selector "tbody tr > td > span.badge.badge-important",
                                    text: appearance.points
          page.should have_selector "tbody tr > td",
                                    text: appearance.prize
          page.should have_selector "tbody tr > td > span.label.label-success",
                                    text: "WL"
        end
      end

      context "when signed in as an admin" do
        it "should list all appearances from current contests"
      end
    end
  end
end
