FactoryBot.define do
  factory :course_to_lms do
    association :course
    association :lms
    sequence(:external_course_id, &:to_s)
  end
end
