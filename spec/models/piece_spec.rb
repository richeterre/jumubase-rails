# == Schema Information
#
# Table name: pieces
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  performance_id :integer
#  epoch_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  minutes        :integer
#  seconds        :integer
#

require 'spec_helper'

describe Piece do

  let (:piece) { FactoryGirl.build(:piece) }

  subject { piece }

  # Attributes
  it { should respond_to(:title) }
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

  it "should not be valid without an associated performance"

  describe "without an associated epoch" do
    before { piece.epoch_id = nil }
    it { should_not be_valid }
  end

  describe "without a minutes value" do
    before { piece.minutes = nil }
    it { should_not be_valid }
  end

  describe "with a non-integer minutes value" do
    before { piece.minutes = 0.5 }
    it { should_not be_valid }
  end

  describe "with a minutes value that is out of range" do
    it "should be invalid" do
      invalid_values = [-1, 60]
      invalid_values.each do |invalid_value|
        piece.minutes = invalid_value
        piece.should_not be_valid
      end
    end
  end

  describe "with a minutes value that is within range" do
    it "should be valid" do
      valid_values = [0, 1, 59]
      valid_values.each do |valid_value|
        piece.minutes = valid_value
        piece.should be_valid
      end
    end
  end

  describe "without a seconds value" do
    before { piece.seconds = nil }
    it { should_not be_valid }
  end

  describe "with a non-integer seconds value" do
    before { piece.seconds = 0.5 }
    it { should_not be_valid }
  end

  describe "with a seconds value that is out of range" do
    it "should be invalid" do
      invalid_values = [-1, 60]
      invalid_values.each do |invalid_value|
        piece.seconds = invalid_value
        piece.should_not be_valid
      end
    end
  end

  describe "with a seconds value that is within range" do
    it "should be valid" do
      valid_values = [0, 1, 59]
      valid_values.each do |valid_value|
        piece.seconds = valid_value
        piece.should be_valid
      end
    end
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
      @piece_with_composer = FactoryGirl.create(:piece, composer: @composer)
    end

    it "should return the right composer" do
      @piece_with_composer.composer.should eq @composer
    end

    it "should destroy the composer together with the piece" do
      composer = @piece_with_composer.composer
      @piece_with_composer.destroy
      Composer.find_by_id(composer.id).should be_nil
    end
  end

  describe "with 2 minutes and 45 seconds" do
    subject { FactoryGirl.create(:piece, minutes: 2, seconds: 45) }
    its(:duration) { should eq 165 }
  end
end
