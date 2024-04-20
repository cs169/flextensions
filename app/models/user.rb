# app/models/user.rb
class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true

    # Relationship with LmsCredential
    has_many :lms_credentials, dependent: :destroy

    # OmniAuth method
    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
          user.email = auth.info.email
          user.name = auth.info.name  # Add this column to your schema if not present
          user.oauth_token = auth.credentials.token
          user.oauth_expires_at = Time.at(auth.credentials.expires_at)
          # Assume you have added 'name' to your users table; otherwise, you can skip this or use another column
      end
    end
  end