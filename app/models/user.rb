# app/models/user.rb
class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true

    # Relationship with LmsCredential
    has_many :lms_credentials, dependent: :destroy

    # Relationship with Extension
    has_many :extensions

    #Relationship with Course (and UserToCourse)
    has_many :user_to_courses
    has_many :courses, :through => :user_to_courses
  end
