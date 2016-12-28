# == Schema Information
#
# Table name: hosts
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  city         :string(255)
#  time_zone    :string(255)      default("Europe/Berlin")
#  country_code :string(255)
#

require 'spec_helper'

describe Host do

  let (:host) { build(:host) }

  subject { host }

  # Attributes
  it { should respond_to(:name) }
  it { should respond_to(:city) }
  it { should respond_to(:country_code) }
  it { should respond_to(:time_zone) }

  # Relationships
  it { should respond_to(:contests) }
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

  describe "without a country code" do
    before { host.country_code = nil }
    it { should_not be_valid }
  end
end
