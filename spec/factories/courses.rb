FactoryBot.define do
  factory :course do
    sequence(:course_name) { |n| "Course #{n}" }
    sequence(:canvas_id, &:to_s)
    sequence(:course_code) { |n| "COURSE#{n}" }
  end
end
