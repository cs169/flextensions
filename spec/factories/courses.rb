FactoryBot.define do
  factory :course do
    sequence(:course_name) { |n| "Course #{n}" }
    sequence(:canvas_id) { |n| "#{n}" }
    sequence(:course_code) { |n| "COURSE#{n}" }
  end
end
