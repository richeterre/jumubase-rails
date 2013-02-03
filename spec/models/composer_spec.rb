# == Schema Information
#
# Table name: composers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  born       :string(255)
#  died       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  piece_id   :integer
#

require 'spec_helper'

describe Composer do

  let (:composer) { FactoryGirl.build(:composer) }

  subject { composer }

  # Attributes
  it { should respond_to(:piece_id) }
  it { should respond_to(:name) }
  it { should respond_to(:born) }
  it { should respond_to(:died) }

  # Relationships
  it { should respond_to(:piece) }

  it { should be_valid }

  describe "without a name" do
    before { composer.name = "" }
    it { should_not be_valid }
  end

  it "should not be valid without an associated piece"
end
