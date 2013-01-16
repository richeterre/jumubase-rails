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
#  age_group       :string(255)
#

require 'spec_helper'

describe Performance do

  let (:performance) { FactoryGirl.build(:performance) }

  subject { performance }

  # Attributes
  it { should respond_to(:category_id) }
  it { should respond_to(:competition_id) }
  it { should respond_to(:stage_venue_id) }
  it { should respond_to(:warmup_time) }
  it { should respond_to(:stage_time) }
  it { should respond_to(:tracing_code) }
  it { should respond_to(:warmup_venue_id) }
  it { should respond_to(:age_group) }

  it "should return the stage time in the competition's time zone"

  it "should return the warmup time in the competition's time zone"

  # Relationships
  it { should respond_to(:category) }
  it { should respond_to(:competition) }
  it { should respond_to(:warmup_venue) }
  it { should respond_to(:stage_venue) }
  it { should respond_to(:appearances) }
  it { should respond_to(:participants) }
  it { should respond_to(:pieces) }

  # Validations

  it { should be_valid }

  describe "without an associated category" do
    before { performance.category = nil }
    it { should_not be_valid }
  end

  describe "without an associated competition" do
    before { performance.competition = nil }
    it { should_not be_valid }
  end

  describe "without at least one associated appearance" do
    before { performance.appearances = [] }
    it { should_not be_valid }
  end

  describe "without at least one associated piece" do
    before { performance.pieces = [] }
    it { should_not be_valid }
  end

  describe "with more than one soloist" do
    before do
      performance.appearances << FactoryGirl.build(:appearance)
    end
    it { should_not be_valid }
  end

  # Callbacks

  it "should update its age group when saved for the first time" do
    expect {
      performance.save
    }.to change(performance, :age_group) # was nil before
  end

  it "should update its age group when saved again later"

  describe "when created" do
    before { performance.save }
    its(:tracing_code) { should_not be_nil }
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

  # Class methods

  it "should respond_to :current" do
    Performance.should respond_to(:current)
  end

  it "should respond_to :in_competition" do
    Performance.should respond_to(:in_competition)
  end

  it "should respond_to :in_category" do
    Performance.should respond_to(:in_category)
  end

  it "should respond_to :in_genre" do
    Performance.should respond_to(:in_genre)
  end

  it "should respond_to :classical" do
    Performance.should respond_to(:classical)
  end

  it "should respond_to :popular" do
    Performance.should respond_to(:popular)
  end

  it "should respond_to :stage_order" do
    Performance.should respond_to(:stage_order)
  end

  it "should respond_to :browsing_order" do
    Performance.should respond_to(:browsing_order)
  end

  it "should return all current performances" do
    @current_performances = FactoryGirl.create_list(:current_performance, 2)
    @old_performances = FactoryGirl.create_list(:old_performance, 2)
    Performance.current.should eq @current_performances
  end

  it "should return all performances for a given competition"

  it "should return all performances for a given category"

  it "should return all performances for a given genre"

  it "should return all classical categories' performances"

  it "should return all popular categories' performances"

  it "should correctly construct a chain of conditions"

  it "should order performances by stage time"

  it "should order performances by category and age group for browsing"

  it "should return all performances sent onwards from a given competition" do
    pending "This needs to be implemented in a new way"
  end

  # Convenience methods

  it { should respond_to(:accompanists) }
  it { should respond_to(:age_group) }
  it { should respond_to(:duration) }
  it { should respond_to(:rounded_duration) }
  it { should respond_to(:rounded_end_time) }

  it "should return all participants with an accompanist role"

  it "should return the correct age group"

  it "should return the correct duration"

  it "should return the duration rounded up to the next 5-minute mark"

  it "should return the correct end time based on rounded duration"

  # Authorizations

  describe "for admin users" do
    it "should allow access to all fields" do
      # Use in controller: @performance.accessible = :all if admin?
      pending "This is required to enable editing of warmup and other non-public fields"
    end
  end
end
