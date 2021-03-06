# == Schema Information
#
# Table name: appearances
#
#  id               :integer          not null, primary key
#  performance_id   :integer
#  participant_id   :integer
#  instrument_id    :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  points           :integer
#  participant_role :string(255)
#

require 'spec_helper'

describe Appearance do

  let (:appearance) { build(:appearance) }

  subject { appearance }

  # Attributes
  it { should respond_to(:performance_id) }
  it { should respond_to(:participant_id) }
  it { should respond_to(:instrument_id) }
  it { should respond_to(:participant_role) }

  # Relationships
  it { should respond_to(:performance) }
  it { should respond_to(:participant) }
  it { should respond_to(:instrument) }

  # Convenience methods
  it { should respond_to(:age_group) }
  it "should return the correct age group for a soloist"
  it "should return the correct age group for a classical accompanist"
  it "should return the correct age group for an ensemblist"
  it "should return the correct age group for a pop accompanist"

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
    before { appearance.participant_role = nil }
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

  # Class methods

  it "should respond_to :with_role" do
    Appearance.should respond_to(:with_role)
  end

  it "should respond_to :pointless" do
    Appearance.should respond_to(:pointless)
  end

  it "should respond_to :role_order" do
    Appearance.should respond_to(:role_order)
  end

  it "should return all appearances with a given role"
  it "should return all appearances without points"
  it "should order appearances by role (solo, accompanist, ensemble)"

  # Result calculations
  describe "based on awarded points" do

    it "should assign the correct prize to different points" do
      # Test for first and second round
      [1, 2].each do |round|

        contest = build(:contest, round: round)
        contest_category = build(:contest_category, contest: contest)
        performance = build(:performance, contest_category: contest_category)
        appearance = performance.appearances.first

        min_prize_points = 25 # Minimum points required to get a prize, adjusted in loop

        # Use prize ranges for current round (index starts at 0, rounds at 1)
        JUMU_PRIZE_POINT_RANGES[round - 1].each do |prize, point_range|
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

      # TODO: Test for different age groups
    end
  end
end
