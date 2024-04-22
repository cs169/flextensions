# app/models/user.rb
class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true

    # Associasions
    has_many :lms_credentials, dependent: :destroy
    has_many :user_to_courses
    has_many :lms_credentials
    has_one :extensions
  end