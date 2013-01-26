# == Schema Information
#
# Table name: competitions
#
#  id               :integer          not null, primary key
#  round_id         :integer
#  host_id          :integer
#  begins           :date
#  ends             :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  certificate_date :date
#  season           :integer
#  signup_deadline  :datetime
#

require 'spec_helper'

describe Competition do

  let (:competition) { FactoryGirl.build(:competition) }

  subject { competition }

  # Attributes
  it { should respond_to(:season) }
  it { should respond_to(:round_id) }
  it { should respond_to(:host_id) }
  it { should respond_to(:begins) }
  it { should respond_to(:ends) }
  it { should respond_to(:signup_deadline) }
  it { should respond_to(:certificate_date) }
  it { should respond_to(:category_ids) }

  # Relationships
  it { should respond_to(:round) }
  it { should respond_to(:host) }
  it { should respond_to(:performances) }
  it { should respond_to(:appearances) }
  it { should respond_to(:participants) }
  it { should respond_to(:categories) }

  # Validations
  it { should be_valid }

  describe "without an associated season" do
    before { competition.season = nil }
    it { should_not be_valid }
  end

  describe "with a season that is not a positive integer" do
    it "should be invalid" do
      invalid_values = [-1, 1.5]
      invalid_values.each do |value|
        competition.season = value
        competition.should_not be_valid
      end
    end
  end

  describe "without an associated round" do
    before { competition.round_id = nil }
    it { should_not be_valid }
  end

  describe "without an associated host" do
    before { competition.host_id = nil }
    it { should_not be_valid }
  end

  describe "without an associated start date" do
    before { competition.begins = nil }
    it { should_not be_valid }
  end

  describe "without an associated end date" do
    before { competition.ends = nil }
    it { should_not be_valid }
  end

  describe "that ends before it begins" do
    before { competition.ends = competition.begins - 1.day }
    it { should_not be_valid }
  end

  describe "that ends on the same day it begins" do
    before { competition.ends = competition.begins }
    it { should be_valid }
  end

  describe "without an associated signup deadline" do
    before { competition.signup_deadline = nil }
    it { should_not be_valid }
  end

  describe "with a signup deadline that is not before the competition begins" do
    it "should be invalid" do
      invalid_deadlines = [competition.begins, competition.begins + 1.hour]
      invalid_deadlines.each do |deadline|
        competition.signup_deadline = deadline
        competition.should_not be_valid
      end
    end
  end

  # Convencience methods

  it { should respond_to(:name) }
  it { should respond_to(:host_name) }
  it { should respond_to(:days) }
  it { should respond_to(:year) }

  describe "should return a name to describe itself" do
    before do
      competition.host = FactoryGirl.build(:host, name: "The Host")
      competition.round = FactoryGirl.build(:round, slug: "Round Slug")
      competition.season = 100
    end

    its(:name) { should eq "The Host, Round Slug 2063" }
  end

  describe "should return the correct host name" do
    before do
      @host = FactoryGirl.build(:host, name: "The Host")
      competition.host = @host
    end

    its(:host_name) { should eq @host.name }
  end

  it "should return the last full day when signup is possible" do
    [Date.today, Date.today + 1.hour].each do |deadline|
      competition.signup_deadline = deadline
      competition.last_signup_date.should eq Date.yesterday
    end
  end

  describe "should return the days it takes place as a range" do
    before do
      competition.begins = @today = Date.today
      competition.ends = @in_3_days = Date.today + 3.days
    end

    its(:days) { should eq (@today..@in_3_days) }
  end

  describe "should return the correct season year" do
    before { competition.season = 100 }
    its(:year) { should eq 2063 }
  end

  it "should be able to return all competitions that are currently ongoing" do
    FactoryGirl.create(:past_competition)
    FactoryGirl.create(:future_competition)
    current_competitions = FactoryGirl.create_list(:current_competition, 2)

    Competition.current.should =~ current_competitions
  end

  it "should be able to return all current competitions whose signup is open" do
    FactoryGirl.create(:past_competition)
    FactoryGirl.create(:future_competition)
    FactoryGirl.create(:deadlined_competition)
    # TODO: Include competition whose deadline is exactly "now"
    current_and_open_competitions = FactoryGirl.create_list(:current_competition, 2)

    Competition.current_and_open.should =~ current_and_open_competitions
  end

  it "should be able to return all competitions of same season and next-higher round" do
    next_round = FactoryGirl.create(:round, level: competition.round.level + 1)
    possible_successors = FactoryGirl.create_list(:competition, 2, round: next_round)

    # We're not interested in these
    FactoryGirl.create(:competition) # same round and season
    FactoryGirl.create(:competition, round: next_round, season: competition.season + 1)
    round_after_next = FactoryGirl.create(:round, level: competition.round.level + 2)
    FactoryGirl.create(:competition, round: round_after_next)

    competition.possible_successors.should =~ possible_successors
  end

  it "should be able to return all competitions of the preceding round in this year" do
    pending "Check against list of current, future and past competitions"
  end
end
