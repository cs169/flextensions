# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
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
