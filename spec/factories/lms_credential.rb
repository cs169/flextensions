FactoryBot.define do
  factory :lms_credential do
    association :user
    lms_id { 1 }
    token { 'fake_token' }
    refresh_token { 'fake_refresh_token' }
    expire_time { 1.hour.from_now }

    before(:create) do |credential|
      # Ensure the LMS with id: 1 exists
      unless Lms.exists?(id: 1)
        Lms.create!(id: 1, lms_name: 'Canvas', use_auth_token: true)
      end
    end
  end
end
