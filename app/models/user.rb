# app/models/user.rb
class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' }

    # Associations
    has_many :lms_credentials, dependent: :destroy

    # Relationship with Extension
    has_many :extensions

    #Relationship with Course (and UserToCourse)
    has_many :user_to_courses
    has_many :courses, :through => :user_to_courses

    def token_expired?
      if users.lms_credentials.any? 
        users.lms_credentials.each do |credential|
          if Time.now > credential.expires_time
            return true
          end
        end
      end
    end
  end