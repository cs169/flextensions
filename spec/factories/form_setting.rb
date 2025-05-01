FactoryBot.define do
  factory :form_setting do
    association :course
    reason_desc { 'Please provide your reason for requesting an extension' }
    documentation_desc { 'Please provide any supporting documentation' }
    documentation_disp { 'optional' }
    custom_q1_disp { 'hidden' }
    custom_q2_disp { 'hidden' }
    custom_q1 { nil }
    custom_q2 { nil }

    trait :with_required_documentation do
      documentation_disp { 'required' }
    end

    trait :with_custom_questions do
      custom_q1_disp { 'optional' }
      custom_q2_disp { 'optional' }
      custom_q1 { 'Custom question 1' }
      custom_q2 { 'Custom question 2' }
    end
  end
end
