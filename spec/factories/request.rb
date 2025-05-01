FactoryBot.define do
  factory :request do
    association :course
    association :user
    association :assignment
    reason { 'Extension request reason' }
    status { 'pending' }
    requested_due_date { 14.days.from_now }

    trait :approved do
      status { 'approved' }
    end

    trait :denied do
      status { 'denied' }
    end
  end
end
