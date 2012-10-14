# -*- encoding : utf-8 -*-

# Remember to have a "vanilla" factory for each class
FactoryGirl.define do
  factory :appearance do
    participant
    performance
    instrument
    role
  end

  factory :category do
    sequence(:name) { |n| "Kategorie #{n}" }

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
      association :round, factory: :current_round
      ends Date.new(JUMU_YEAR, 01, 01)
    end

    factory :future_competition do
      ends Date.new(JUMU_YEAR + 1, 01, 01)
    end
  end

  factory :composer do
    sequence(:name) { |n| "Composer #{n}" }
  end

  factory :country do
    sequence(:name) { |n| "Country #{n}" }
    sequence(:slug) { |n| "C#{n}" }
  end

  factory :epoch do
    sequence(:name) { |n| "Epoch #{n}" }
    sequence(:slug) { |n| "E#{n}" }
  end

  factory :host do
    sequence(:name) { |n| "Host #{n}" }
    country
  end

  factory :instrument do
    sequence(:name) { |n| "Instrument #{n}" }
  end

  factory :participant do
    sequence(:first_name) { |n| "Vorname #{n}" }
    sequence(:last_name) { |n| "Nachname #{n}" }
    gender "f"
    birthdate Date.today - 15.years
    country
    phone "12345"
    sequence(:email) { |n| "teilnehmer.#{n}@example.org" }
  end

  factory :performance do
    category
    competition

    after(:build) do |performance|
      performance.appearances << FactoryGirl.build(:appearance, performance: performance)
      performance.pieces << FactoryGirl.build(:piece, performance: performance)
    end

    factory :current_performance do
      association :competition, factory: :current_competition
    end
  end

  factory :piece do
    sequence(:title) { |n| "Stück #{n}" }
    epoch
    minutes 4
    seconds 33
  end

  factory :role do
    name "Solist"
    slug "S"

    factory :accompanist_role do
      name "Begleiter"
      slug "B"
    end

    factory :ensemblist_role do
      name "Mitglied eines Ensembles"
      slug "E"
    end
  end

  factory :round do
    level 1
    name "Regionalwettbewerb"
    slug "RW"

    factory :current_round do
      level JUMU_ROUND
      name ["Regionalwettbewerb", "Landeswettbewerb", "Bundeswettbewerb"].at(JUMU_ROUND - 1)
      slug ["RW", "LW", "BW"].at(JUMU_ROUND - 1)
    end
  end
end
