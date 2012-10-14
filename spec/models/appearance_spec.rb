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
end
