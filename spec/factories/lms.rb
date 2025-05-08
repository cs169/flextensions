FactoryBot.define do
  factory :lms do
    id { 1 } # Explicitly set id to 1 (must be hardcoded)
    lms_name { 'canvas' }
    use_auth_token { true }
  end
end
