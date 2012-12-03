# == Schema Information
#
# Table name: appearances
#
#  id             :integer          not null, primary key
#  performance_id :integer
#  participant_id :integer
#  instrument_id  :integer
#  role_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  points         :integer
#

require 'spec_helper'

describe Appearance do

  let (:appearance) { FactoryGirl.build(:appearance) }

  subject { appearance }

  # Attributes
  it { should respond_to(:performance_id) }
  it { should respond_to(:participant_id) }
  it { should respond_to(:instrument_id) }
  it { should respond_to(:role_id) }

  # Relationships
  it { should respond_to(:performance) }
  it { should respond_to(:participant) }
  it { should respond_to(:instrument) }
  it { should respond_to(:role) }

  # Convenience methods
  # ...

  # Validations
  it { should be_valid }

  it "should not be valid without an associated performance"
  it "should not be valid without an associated participant"

  describe "without an associated instrument" do
    before { appearance.instrument_id = nil }
    it { should_not be_valid }
  end

  describe "without an associated role" do
    before { appearance.role_id = nil }
    it { should_not be_valid }
  end

  describe "with points" do
    context "that are integers and within range" do
      it "should be valid" do
        [0, 1, 24, 25].each do |valid_value|
          appearance.points = valid_value
          appearance.should be_valid
        end
      end
    end

    context "that are not integers" do
      it "should be invalid" do
        [1.5, 24.9].each do |invalid_value|
          appearance.points = invalid_value
          appearance.should_not be_valid
        end
      end
    end

    context "that are out of range" do
      it "should be invalid" do
        [-1, 26].each do |invalid_value|
          appearance.points = invalid_value
          appearance.should_not be_valid
        end
      end
    end
  end

  # Result calculations
  describe "based on awarded points" do
    before do
      @rounds = [FactoryGirl.build(:round), FactoryGirl.build(:second_round)]
    end

    it "should assign the correct prize to different points" do
      # Test for first and second round
      @rounds.each do |round|

        competition = FactoryGirl.build(:competition, round: round)
        performance = FactoryGirl.build(:performance, competition: competition)
        appearance = performance.appearances.first

        min_prize_points = 25 # Minimum points required to get a prize, adjusted in loop

        # Use prize ranges for current round (index starts at 0, rounds at 1)
        JUMU_PRIZE_POINT_RANGES[round.level - 1].each do |prize, point_range|
          appearance.points = point_range.first
          appearance.prize.should eq prize
          appearance.points = point_range.first - 1 # one below range
          appearance.prize.should_not eq prize

          appearance.points = point_range.last
          appearance.prize.should eq prize
          appearance.points = point_range.last + 1 # one above range
          appearance.prize.should_not eq prize

          min_prize_points = point_range.min if point_range.min < min_prize_points # Push down minimum
        end

        appearance.points = min_prize_points - 1 # one below prize minimum
        appearance.prize.should be_nil
      end
    end

    it "should correctly determine whether an appearance may advance to the next round" do
      @rounds.each do |round|
        competition = FactoryGirl.build(:competition, round: round)
        performance = FactoryGirl.build(:performance, competition: competition)
        appearance = performance.appearances.first

        advancing_points = 23..25
        advancing_points.each do |points|
          appearance.points = points
          appearance.may_advance_to_next_round?.should be(true)
        end

        non_advancing_points = 0..22
        non_advancing_points.each do |points|
          appearance.points = points
          appearance.may_advance_to_next_round?.should_not be(true)
        end
      end

      pending "Check for age group and category limitations"
    end
  end
end
