# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  admin      :boolean          default(FALSE)
#  canvas_uid :string
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  student_id :string
#
# Indexes
#
#  index_users_on_canvas_uid  (canvas_uid) UNIQUE
#  index_users_on_email       (email) UNIQUE
#
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:canvas_uid, &:to_s)
    sequence(:name) { |n| "User #{n}" }

    factory :admin do
      admin { true }
    end

    # Allow passing in :courses and :role
    transient do
      courses { [] }
      role { 'student' }
    end

    after(:create) do |user, evaluator|
      evaluator.courses.each do |course|
        create(:user_to_course, user: user, course: course, role: evaluator.role)
      end
    end

    # Test with a long refresh time to minimize the need to mock things out.
    trait :with_canvas_token do
      after(:create) do |user|
        create(:lms_credential, user: user, expire_time: 10.days.from_now)
      end
    end

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
