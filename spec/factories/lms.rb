FactoryBot.define do
  factory :lms do
    sequence(:id) { |n| n }
    lms_name { 'Canvas' }
    use_auth_token { true }

    trait :canvas do
      id { 1 }
      lms_name { 'Canvas' }
    end

    trait :gradescope do
      id { 2 }
      lms_name { 'Gradescope' }
      use_auth_token { false }
    end
  end
end
