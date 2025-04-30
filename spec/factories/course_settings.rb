FactoryBot.define do
  factory :course_settings do
    association :course
    enable_extensions { true }
    auto_approve_days { 2 }
  end
end
