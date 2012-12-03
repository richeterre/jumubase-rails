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
    season JUMU_SEASON + 3
    round
    host
    begins { ends - 5.days }
    ends { Date.today + 3.years }
    signup_deadline { begins - 1.month }

    factory :past_competition do
      season JUMU_SEASON - 1
      ends Date.new((Date.today - 1.year).year, 12, 31)
    end

    factory :current_competition do
      season JUMU_SEASON
      association :round, factory: :current_round
      ends { Date.today + 1.month }
      signup_deadline { Date.today + 1.day }
    end

    factory :future_competition do
      season JUMU_SEASON + 1
      ends Date.new((Date.today + 1.year).year, 01, 01)
    end

    # Create an upcoming competition whose deadline has passed
    factory :deadlined_competition do
      season JUMU_SEASON
      association :round, factory: :current_round
      ends { Date.today + 1.month }
      signup_deadline { Date.today - 1.day }
    end
  end

  factory :composer do
    sequence(:name) { |n| "Composer #{n}" }
  end

  factory :country do
    sequence(:name) { |n| "Country #{n}" }
    sequence(:slug) { |n| "C#{n}" }
    country_code "fam"
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
    sequence(:email) { |n| "teilnehmer_#{n}@example.org" }
  end

  factory :performance do
    category
    competition

    after(:build) do |performance|
      performance.appearances << FactoryGirl.build(:appearance, performance: performance)
      performance.pieces << FactoryGirl.build(:piece, performance: performance)
    end

    factory :current_performance do
      association :category, factory: :active_category
      association :competition, factory: :current_competition
    end

    factory :old_performance do
      association :competition, factory: :past_competition
    end
  end

  factory :piece do
    sequence(:title) { |n| "Stück #{n}" }
    composer
    performance
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

    factory :second_round do
      level 2
      name "Landeswettbewerb"
      slug "LW"
    end

    factory :current_round do
      level JUMU_ROUND
      name ["Regionalwettbewerb", "Landeswettbewerb", "Bundeswettbewerb"].at(JUMU_ROUND - 1)
      slug ["RW", "LW", "BW"].at(JUMU_ROUND - 1)
    end
  end

  factory :user do
    sequence(:first_name) { |n| "Vorname #{n}" }
    sequence(:last_name) { |n| "Nachname #{n}" }
    sequence(:email) { |n| "person_#{n}@example.org" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
end
