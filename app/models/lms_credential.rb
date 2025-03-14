# app/models/lms_credential.rb
class LmsCredential < ApplicationRecord
  # Belongs to a User
  belongs_to :user

  # Encryption for tokens
  encrypts :token, :refresh_token

  # LMS must exist
  validates :lms_name, presence: true
end
