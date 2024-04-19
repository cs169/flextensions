# app/models/user.rb
class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true

    # Relationship with LmsCredential
    has_many :lms_credentials, dependent: :destroy
  end
