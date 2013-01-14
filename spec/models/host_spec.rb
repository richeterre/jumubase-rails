# == Schema Information
#
# Table name: hosts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  city       :string(255)
#  time_zone  :string(255)      default("Europe/Berlin")
#

require 'spec_helper'

describe Host do

  let (:host) { FactoryGirl.build(:host) }

  subject { host }

  # Attributes
  it { should respond_to(:name) }
  it { should respond_to(:city) }
  it { should respond_to(:country_id) }
  it { should respond_to(:time_zone) }

  # Relationships
  it { should respond_to(:country) }
  it { should respond_to(:competitions) }
  it { should respond_to(:venues) }

  it { should be_valid }

  describe "without a name" do
    before { host.name = "" }
    it { should_not be_valid }
  end

  describe "without a city" do
    before { host.city = "" }
    it { should_not be_valid }
  end

  describe "without an associated country" do
    before { host.country = nil }
    it { should_not be_valid }
  end
end
