FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:canvas_uid, &:to_s)
    sequence(:name) { |n| "User #{n}" }

    factory :teacher do
      after(:create) { |user| create(:user_to_course, user: user, role: 'teacher') }
    end

    factory :ta do
      after(:create) { |user| create(:user_to_course, user: user, role: 'ta') }
    end

    factory :student do
      after(:create) { |user| create(:user_to_course, user: user, role: 'student') }
    end
  end
end
