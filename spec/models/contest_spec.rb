# == Schema Information
#
# Table name: contests
#
#  id                :integer          not null, primary key
#  host_id           :integer
#  begins            :date
#  ends              :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  certificate_date  :date
#  season            :integer
#  signup_deadline   :date
#  timetables_public :boolean          default(FALSE)
#  round             :integer
#

require 'spec_helper'

describe Contest do

  let (:contest) { build(:contest) }

  subject { contest }

  # Attributes
  it { should respond_to(:season) }
  it { should respond_to(:round) }
  it { should respond_to(:host_id) }
  it { should respond_to(:begins) }
  it { should respond_to(:ends) }
  it { should respond_to(:signup_deadline) }
  it { should respond_to(:certificate_date) }
  it { should respond_to(:timetables_public) }

  # Relationships
  it { should respond_to(:host) }
  it { should respond_to(:performances) }
  it { should respond_to(:appearances) }
  it { should respond_to(:participants) }
  it { should respond_to(:contest_categories) }

  # Validations
  it { should be_valid }

  describe "without an associated season" do
    before { contest.season = nil }
    it { should_not be_valid }
  end

  describe "with a season that is not a positive integer" do
    it "should be invalid" do
      invalid_values = [-1, 1.5]
      invalid_values.each do |value|
        contest.season = value
        contest.should_not be_valid
      end
    end
  end

  describe "without a round" do
    before { contest.round = nil }
    it { should_not be_valid }
  end

  describe "without an associated host" do
    before { contest.host_id = nil }
    it { should_not be_valid }
  end

  describe "without an associated start date" do
    before { contest.begins = nil }
    it { should_not be_valid }
  end

  describe "without an associated end date" do
    before { contest.ends = nil }
    it { should_not be_valid }
  end

  describe "that ends before it begins" do
    before { contest.ends = contest.begins - 1.day }
    it { should_not be_valid }
  end

  describe "that ends on the same day it begins" do
    before { contest.ends = contest.begins }
    it { should be_valid }
  end

  describe "without an associated signup deadline" do
    before { contest.signup_deadline = nil }
    it { should_not be_valid }
  end

  describe "with a signup deadline that is not before the contest begins" do
    it "should be invalid" do
      invalid_deadlines = [contest.begins, contest.begins + 1.hour]
      invalid_deadlines.each do |deadline|
        contest.signup_deadline = deadline
        contest.should_not be_valid
      end
    end
  end

  # Class methods

  it "should respond_to :seasonal_in_round" do
    Contest.should respond_to(:seasonal_in_round)
  end

  it "should respond_to :current" do
    Contest.should respond_to(:current)
  end

  it "should respond_to :open" do
    Contest.should respond_to(:open)
  end

  it "should respond_to :preceding" do
    Contest.should respond_to(:preceding)
  end

  it "should be able to return all contests of the current season in given round" do
    create(:past_contest)
    create(:future_contest)
    seasonal_rws = create_list(:current_contest, 2, round: 1)
    seasonal_lws = create_list(:current_contest, 2, round: 2)

    Contest.seasonal_in_round(1).should =~ seasonal_rws
    Contest.seasonal_in_round(2).should =~ seasonal_lws
  end

  it "should be able to return all contests that are currently ongoing" do
    create(:past_contest)
    create(:future_contest)
    current_contests = create_list(:current_contest, 2)

    Contest.current.should =~ current_contests
  end

  it "should be able to return all current contests whose signup is open" do
    create(:past_contest)
    create(:future_contest)
    create(:deadlined_contest)
    # TODO: Include contest whose deadline is exactly "now"
    current_and_open_contests = create_list(:current_contest, 2)

    Contest.current.open.should =~ current_and_open_contests
  end

  # Convenience methods

  it { should respond_to(:name) }
  it { should respond_to(:host_name) }
  it { should respond_to(:days) }
  it { should respond_to(:year) }
  it { should respond_to(:round_name_and_year) }
  it { should respond_to(:can_be_advanced_to?) }
  it { should respond_to(:can_be_advanced_from?) }

  describe "should return a name to describe itself" do
    before do
      contest.host = build(:host, name: "The Host")
      contest.round = 1
      contest.season = 100
    end

    its(:name) { should eq "The Host, RW 2063" }
  end

  describe "should return the correct host name" do
    before do
      @host = build(:host, name: "The Host")
      contest.host = @host
    end

    its(:host_name) { should eq @host.name }
  end

  describe "should return the days it takes place as a range" do
    before do
      contest.begins = @today = Date.today
      contest.ends = @in_3_days = Date.today + 3.days
    end

    its(:days) { should eq (@today..@in_3_days) }
  end

  describe "should return the correct season year" do
    before { contest.season = 100 }
    its(:year) { should eq 2063 }
  end

  describe "should return the correct round name with year" do
    before { contest.season = 100 }
    its(:round_name_and_year) { should eq "Regionalwettbewerb 2063" }
  end

  it "should return whether performances can advance here" do
    contest.round = 1
    contest.can_be_advanced_to?.should be_false
    [2, 3].each do |round|
      contest.round = round
      contest.can_be_advanced_to?.should be_true
    end
  end

  it "should return whether performances can advance onwards from here" do
    contest.round = 1
    contest.can_be_advanced_from?.should be_true
    [2, 3].each do |round|
      contest.round = round
      contest.can_be_advanced_from?.should be_false
    end
  end

  it "should be able to return all contests of same season and next-higher round" do
    next_round = contest.round + 1
    possible_successors = create_list(:contest, 2, round: next_round)

    # We're not interested in these
    create(:contest) # same round and season
    create(:contest, round: next_round, season: contest.season + 1)
    round_after_next = contest.round + 2
    create(:contest, round: round_after_next)

    contest.possible_successors.should =~ possible_successors
  end
end
