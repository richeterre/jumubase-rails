# == Schema Information
#
# Table name: performances
#
#  id             :integer          not null, primary key
#  category_id    :integer
#  competition_id :integer
#  warmup_time    :datetime
#  stage_time     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tracing_code   :string(255)
#  age_group      :string(255)
#  predecessor_id :integer
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
  it { should respond_to(:predecessor) }
  it { should respond_to(:successor) }
  it { should respond_to(:tracing_code) }
  it { should respond_to(:warmup_venue_id) }
  it { should respond_to(:age_group) }

  it "should return the stage time in the competition's time zone"

  it "should return the warmup time in the competition's time zone"

  it "should cease being its successor's predecessor when destroyed" do
    performance.save
    successor = FactoryGirl.create(:performance, predecessor: performance)
    Performance.find(performance).destroy
    Performance.find(successor).predecessor_id.should be_nil
  end

  # Extensions
  it { should respond_to(:amoeba_dup) } # Duplication with 'amoeba' gem

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

  describe "with a single ensemblist" do
    before do
      performance.appearances = [FactoryGirl.build(:ensemble_appearance)]
    end
    it { should_not be_valid }
  end

  describe "with all participants being accompanists" do
    before do
      performance.appearances.clear
      performance.appearances << FactoryGirl.build(:acc_appearance)
    end
    it { should_not be_valid }
  end

  describe "with both ensemblists and other participant roles" do
    it "should not be valid" do
      # Soloist & ensemblist
      performance.appearances << FactoryGirl.build(:ensemble_appearance)
      performance.should_not be_valid

      # Accompanist & ensemblist
      performance.appearances = [FactoryGirl.build(:acc_appearance)]
      performance.appearances << FactoryGirl.build(:ensemble_appearance)
      performance.should_not be_valid
    end
  end

  describe "with a soloist and one or more accompanists" do
    it "should be valid" do
      performance.appearances << FactoryGirl.build(:acc_appearance)
      performance.should be_valid # for one accompanist

      performance.appearances << FactoryGirl.build(:acc_appearance)
      performance.should be_valid # for many accompanists
    end
  end

  describe "with all participants being ensemblists" do
    before do
      performance.appearances = FactoryGirl.build_list(:ensemble_appearance, 2)
    end
    it { should be_valid }
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

  it "should respond_to :advanced_from_competition" do
    Performance.should respond_to(:advanced_from_competition)
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

  it "should respond_to :on_date" do
    Performance.should respond_to(:on_date)
  end

  it "should respond_to :stage_order" do
    Performance.should respond_to(:stage_order)
  end

  it "should respond_to :browsing_order" do
    Performance.should respond_to(:browsing_order)
  end

  it "should return all current performances" do
    current_performances = FactoryGirl.create_list(:current_performance, 2)
    old_performances = FactoryGirl.create_list(:old_performance, 2)
    Performance.current.should =~ current_performances
  end

  it "should return all performances for a given competition"

  it "should return all performances that advanced from a given competition"

  it "should return all performances for a given category"

  it "should return all performances for a given genre"

  it "should return all classical categories' performances"

  it "should return all popular categories' performances"

  it "should return all performances on a given date"

  it "should correctly construct a chain of conditions"

  it "should order performances by stage time"

  it "should order performances by category and age group for browsing"

  it "should return all performances sent onwards from a given competition" do
    pending "This needs to be implemented in a new way"
  end

  # Convenience methods

  it { should respond_to(:associated_host) }
  it { should respond_to(:associated_country) }
  it { should respond_to(:soloist) }
  it { should respond_to(:accompanists) }
  it { should respond_to(:age_group) }
  it { should respond_to(:duration) }
  it { should respond_to(:rounded_duration) }
  it { should respond_to(:rounded_end_time) }
  it { should respond_to(:advances_to_next_round?) }

  it "should return the associated host" do
    # This should be its own competition host or that of its predecessor, depending on round
  end

  it "should return the associated country"

  it "should return the soloist participant, if any"

  it "should return all participants with an accompanist role"

  it "should return the correct age group"

  it "should return the correct duration"

  it "should return the duration rounded up to the next 5-minute mark"

  it "should return the correct end time based on rounded duration"

  it "should state correctly whether it is eligible for migration to next round" do
    solo_acc_performance = FactoryGirl.build(:current_solo_acc_performance)
    solo_acc_performance.accompanists.each do |accompanist|
      accompanist.points = 23
    end
    solo_acc_performance.soloist.points = 22 # Soloist doesn't advance
    solo_acc_performance.advances_to_next_round?.should be(false)
    solo_acc_performance.soloist.points = 23 # Soloist advances as well
    solo_acc_performance.advances_to_next_round?.should be(true)

    ensemble_performance = FactoryGirl.build(:current_ensemble_performance)
    ensemble_performance.appearances.each do |appearance|
      appearance.points = 22 # Ensemblists don't advance
    end
    ensemble_performance.advances_to_next_round?.should be(false)
    ensemble_performance.appearances.each do |appearance|
      appearance.points = 23 # Ensemblists advance
    end
    ensemble_performance.advances_to_next_round?.should be(true)

    # TODO: Include tests for KiMu, pop categories
  end

  # Authorizations

  describe "for admin users" do
    it "should allow access to all fields" do
      # Use in controller: @performance.accessible = :all if admin?
      pending "This is required to enable editing of warmup and other non-public fields"
    end
  end
end
