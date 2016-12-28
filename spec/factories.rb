# -*- encoding : utf-8 -*-

# Remember to have a "vanilla" factory for each class
FactoryGirl.define do
  factory :appearance do
    participant
    performance
    instrument
    participant_role 'soloist'

    factory :acc_appearance do
      participant_role 'accompanist'
    end

    factory :ensemble_appearance do
      participant_role 'ensemblist'
    end
  end

  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    sequence(:slug) { |n| "cat_#{n}" }
    max_round 3
    official_min_age_group 'Ia'
    official_max_age_group 'VII'
  end

  factory :contest do
    season JUMU_SEASON + 3
    round 1
    host
    begins { ends - 5.days }
    ends { Date.today + 3.years }
    signup_deadline { begins - 1.month }

    factory :past_contest do
      season JUMU_SEASON - 1
      ends { Date.today - 1.year }
    end

    factory :current_contest do
      season JUMU_SEASON
      round JUMU_ROUND
      ends { Date.today + 1.month }
      signup_deadline { Date.tomorrow }
    end

    factory :future_contest do
      season JUMU_SEASON + 1
      ends { Date.today + 1.year }
    end

    # Create an upcoming contest whose deadline has passed
    factory :deadlined_contest do
      season JUMU_SEASON
      round JUMU_ROUND
      ends { Date.today + 1.month }
      signup_deadline { Date.yesterday }
    end
  end

  factory :contest_category do
    category
    contest

    factory :current_contest_category do
      association :contest, factory: :current_contest
    end

    factory :past_contest_category do
      association :contest, factory: :past_contest
    end
  end

  factory :host do
    sequence(:name) { |n| "Host #{n}" }
    sequence(:city) { |n| "City #{n}" }
    country_code "xyz"
  end

  factory :instrument do
    sequence(:name) { |n| "Instrument #{n}" }
  end

  factory :participant do
    sequence(:first_name) { |n| "Participant #{n}" }
    sequence(:last_name) { |n| "Last Name #{n}" }
    birthdate Date.new(JUMU_YEAR, 01, 01) - 14.years # makes AG III
    phone "12345"
    sequence(:email) { |n| "participant_#{n}@example.org" }
  end

  factory :performance do
    contest_category

    after(:build) do |performance|
      performance.appearances << build(:appearance, performance: performance)
      performance.pieces << build(:piece, performance: performance)
    end

    factory :current_performance do
      association :contest_category, factory: :current_contest_category

      factory :current_solo_acc_performance do
        after(:build) do |performance|
          # Add accompanist to the soloist added earlier
          performance.appearances << build(:acc_appearance, performance: performance)
        end
      end

      factory :current_ensemble_performance do
        after(:build) do |performance|
          # Replace soloist added earlier by two ensemblists
          performance.appearances = build_list(:ensemble_appearance, 2, performance: performance)
        end
      end
    end

    factory :old_performance do
      association :contest_category, factory: :past_contest_category
    end
  end

  factory :piece do
    sequence(:title) { |n| "Stück #{n}" }
    sequence(:composer_name) { |n| "Komponist #{n}" }
    performance
    epoch "f"
    minutes 4
    seconds 33
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
