FactoryBot.define do
  factory :api_token do
    association :course
    association :user
    association :created_by, factory: :user
    read_write { false }
    expires_at { 30.days.from_now }

    trait :read_write do
      read_write { true }
    end

    trait :expired do
      expires_at { 1.day.ago }
    end

    trait :revoked do
      revoked_at { 1.day.ago }
    end
  end
end
