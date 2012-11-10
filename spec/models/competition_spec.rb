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
#

require 'spec_helper'

describe Competition do

  let (:competition) { FactoryGirl.build(:competition) }

  subject { competition }

  it { should respond_to(:season) }
  it { should respond_to(:round_id) }
  it { should respond_to(:host_id) }
  it { should respond_to(:begins) }
  it { should respond_to(:ends) }
  it { should respond_to(:certificate_date) }
  it { should respond_to(:category_ids) }

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

  it "should be able to return all competitions that are currently ongoing" do
    past_competitions = FactoryGirl.create_list(:past_competition, 3)
    current_competitions = FactoryGirl.create_list(:current_competition, 3)
    future_competitions = FactoryGirl.create_list(:future_competition, 3)

    Competition.current.should eq current_competitions

    pending "Check against list of current, future and past competitions. IMPORTANT: Handle year spillover!"
  end

  it "should be able to return all competitions of the preceding round in this year" do
    pending "Check against list of current, future and past competitions"
  end
end
