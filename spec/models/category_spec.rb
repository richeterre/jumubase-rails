# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  solo       :boolean
#  ensemble   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  popular    :boolean
#  slug       :string(255)
#  active     :boolean
#

require 'spec_helper'

describe Category do

  let (:category) { FactoryGirl.create(:category) }

  subject { category }

  it { should respond_to(:name) }
  it { should respond_to(:solo) }
  it { should respond_to(:ensemble) }
  it { should respond_to(:popular) }

  it { should be_valid }

  describe "without a name" do
    before { category.name = "" }
    it { should_not be_valid }
  end

  it "should be able to return all categories that are currently active" do
    pending "Check against list of active and non-active categories"
  end
end
