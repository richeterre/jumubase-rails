# -*- encoding : utf-8 -*-

# Remember to have a "vanilla" factory for each class
FactoryGirl.define do
  factory :category do
    sequence :name do |n|
      "Kategorie #{n}"
    end

    factory :active_category do
      active true
    end
  end

  factory :competition do
    round
    host
    begins { ends - 5.days }
    ends { Date.today + 3.years }

    factory :old_competition do
      ends Date.new(JUMU_YEAR - 1, 12, 31)
    end

    factory :current_competition do
      ends Date.new(JUMU_YEAR, 01, 01)
    end

    factory :future_competition do
      ends Date.new(JUMU_YEAR + 1, 01, 01)
    end
  end

  factory :country do
    name "Deutschland"
    slug "D"
  end

  factory :host do
    sequence :name do |n|
      "DS Stadt #{n}"
    end
    country
  end

  factory :performance do
    category
    competition
  end

  factory :round do
    level 1
    name "Regionalwettbewerb"
    slug "RW"
  end
end