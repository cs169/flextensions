FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:canvas_uid) { |n| "#{n}" }
    sequence(:name) { |n| "User #{n}" }

    factory :teacher do
      # Add teacher-specific attributes if needed
    end

    factory :student do
      # Add student-specific attributes if needed
    end
  end
end
