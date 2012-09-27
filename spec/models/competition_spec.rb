require 'spec_helper'

describe Competition do

  let (:competition) { FactoryGirl.create(:competition) }

  subject { competition }

  it { should respond_to(:round_id) }
  it { should respond_to(:host_id) }
  it { should respond_to(:begins) }
  it { should respond_to(:ends) }
  it { should respond_to(:certificate_date) }
  it { should respond_to(:category_ids) }

  it { should be_valid }

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

  it "should be able to return all competitions that are currently ongoing" do
    pending "Check against list of current, future and past competitions. IMPORTANT: Handle year spillover!"
  end

  it "should be able to return all competitions of the preceding round in this year" do
    pending "Check against list of current, future and past competitions"
  end
end