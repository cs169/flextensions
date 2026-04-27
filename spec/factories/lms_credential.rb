FactoryBot.define do
  factory :lms_credential do
    association :user
    lms_id { 1 }
    token { 'fake_token' }
    refresh_token { 'fake_refresh_token' }
    expire_time { 1.hour.from_now }
  end
end
