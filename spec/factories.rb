# -*- encoding : utf-8 -*-

# Remember to have a "vanilla" factory for each class
FactoryGirl.define do
  factory :appearance do
    participant
    performance
    instrument
    participant_role 'soloist'

    factory :acc_appearance do
      particiant_role 'accompanist'
    end

    factory :ensemble_appearance do
      particiant_role 'ensemblist'
    end
  end

  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    sequence(:slug) { |n| "cat_#{n}" }

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
      ends { Date.today - 1.year }
    end

    factory :current_competition do
      season JUMU_SEASON
      association :round, factory: :current_round
      ends { Date.today + 1.month }
      signup_deadline { Date.tomorrow }
    end

    factory :future_competition do
      season JUMU_SEASON + 1
      ends { Date.today + 1.year }
    end

    # Create an upcoming competition whose deadline has passed
    factory :deadlined_competition do
      season JUMU_SEASON
      association :round, factory: :current_round
      ends { Date.today + 1.month }
      signup_deadline { Date.yesterday }
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
    sequence(:city) { |n| "City #{n}" }
    country
  end

  factory :instrument do
    sequence(:name) { |n| "Instrument #{n}" }
  end

  factory :participant do
    sequence(:first_name) { |n| "Participant #{n}" }
    sequence(:last_name) { |n| "Last Name #{n}" }
    gender "f"
    birthdate Date.new(JUMU_YEAR, 01, 01) - 14.years # makes AG III
    country
    phone "12345"
    sequence(:email) { |n| "participant_#{n}@example.org" }
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

      factory :current_solo_acc_performance do
        after(:build) do |performance|
          # Add accompanist to the soloist added earlier
          performance.appearances << FactoryGirl.build(:acc_appearance, performance: performance)
        end
      end

      factory :current_ensemble_performance do
        after(:build) do |performance|
          # Replace soloist added earlier by two ensemblists
          performance.appearances = FactoryGirl.build_list(:ensemble_appearance, 2, performance: performance)
        end
      end
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
    sequence(:first_name) { |n| "User #{n}" }
    sequence(:last_name) { |n| "Last Name #{n}" }
    sequence(:email) { |n| "person_#{n}@example.org" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
end
