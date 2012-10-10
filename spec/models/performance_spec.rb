# == Schema Information
#
# Table name: performances
#
#  id              :integer          not null, primary key
#  category_id     :integer
#  competition_id  :integer
#  stage_venue_id  :integer
#  warmup_time     :datetime
#  stage_time      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  tracing_code    :string(255)
#  warmup_venue_id :integer
#

require 'spec_helper'

describe Performance do

  let (:performance) { FactoryGirl.build(:performance) }

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

  describe "for admin users" do
    it "should allow access to all fields" do
      pending "This is required to enable editing of warmup and other non-public fields"
    end
  end
end
