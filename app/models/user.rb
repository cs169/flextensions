# app/models/user.rb
class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' }

    # Associasions
    has_many :lms_credentials, dependent: :destroy
    has_many :user_to_courses
    has_many :extensions
  end