require 'spec_helper'

describe Piece do

  let (:piece) { FactoryGirl.create(:piece) }

  subject { piece }

  # Attributes
  it { should respond_to(:title) }
  it { should respond_to(:composer_id) }
  it { should respond_to(:performance_id) }
  it { should respond_to(:epoch_id) }
  it { should respond_to(:minutes) }
  it { should respond_to(:seconds) }

  # Relationships
  it { should respond_to(:composer) }
  it { should respond_to(:performance) }
  it { should respond_to(:epoch) }

  # Convenience methods
  it { should respond_to(:duration) }

  it { should be_valid }

  describe "without a title" do
    before { piece.title = "" }
    it { should_not be_valid }
  end

  describe "without an associated epoch" do
    before { piece.epoch_id = nil }
    it { should_not be_valid }
  end

  describe "without a minutes value" do
    before { piece.minutes = nil }
    it { should_not be_valid }
  end

  describe "without a seconds value" do
    before { piece.seconds = nil }
    it { should_not be_valid }
  end

  describe "when creating a piece with valid attributes and nested composers" do
    before do
      @composers = {}
    end

    it "should change the number of pieces by 1" do
      pending "This should be tested using a Factory that makes composers"
    end
  end

  describe "with an associated composer" do
    before do
      @composer = FactoryGirl.create(:composer)
    end

    it "should return the right composer" do
      FactoryGirl.create(:piece, composer: composer).composer.should eq composer
    end

    it "should destroy the composer together with the piece"
  end
end