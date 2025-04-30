FactoryBot.define do
  factory :lms do
    lms_name { 'Canvas' }
    use_auth_token { true }
  end
end
