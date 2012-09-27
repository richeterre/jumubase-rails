require 'spec_helper'

describe Performance do

  let (:performance) { FactoryGirl.create(:performance) }

  subject { performance }

  it { should respond_to(:category_id) }
  it { should respond_to(:competition_id) }

  it { should be_valid }

  describe "without an associated category" do
    before { performance.category = nil }
    it { should_not be_valid }
  end

  describe "without an associated competition" do
    before { performance.competition = nil }
    it { should_not be_valid }
  end

  describe "when creating a performance with valid attributes and nested pieces and participants" do
    before do
      @pieces = {}
      @participants = {}
    end

    it "should change the number of performances by 1" do
      pending "This should be tested using a Factory that makes pieces and participants"
    end
  end

  it "should return all performances sent onwards from a given competition" do
    pending "This needs to be implemented in a new way"
  end
end