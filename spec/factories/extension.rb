FactoryBot.define do
  factory :extension do
    association :assignment
    sequence(:student_email) { |n| "student#{n}@example.com" }
    initial_due_date { 7.days.from_now }
    new_due_date { 14.days.from_now }
  end
end
