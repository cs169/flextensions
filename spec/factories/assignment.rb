FactoryBot.define do
  factory :assignment do
    sequence(:name) { |n| "Assignment #{n}" }
    association :course_to_lms
    sequence(:external_assignment_id) { |n| "assignment_#{n}" }
    enabled { true }
    due_date { 7.days.from_now }
    late_due_date { 10.days.from_now }
  end
end
