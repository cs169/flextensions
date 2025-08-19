# app/models/user.rb
# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  canvas_uid :string
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  student_id :string
#
# Indexes
#
#  index_users_on_canvas_uid  (canvas_uid) UNIQUE
#  index_users_on_email       (email) UNIQUE
#
class User < ApplicationRecord
  has_many :requests, dependent: :nullify
  # This association is for when a request is processed by a different user:
  has_many :processed_requests, class_name: 'Request', foreign_key: 'last_processed_by_id', inverse_of: :last_processed_by

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' }

  # Associations
  has_many :lms_credentials, dependent: :destroy

  # Relationship with Extension
  has_many :extensions

  # Relationship with Course (and UserToCourse)
  has_many :user_to_courses
  has_many :courses, through: :user_to_courses

  def token_expired?
    return false unless lms_credentials.any?

    lms_credentials.each do |credential|
      return true if Time.zone.now > credential.expire_time
    end

    false
  end

  # Check if token will expire within the specified buffer time
  def token_expires_soon?(buffer_minutes = 15)
    return false unless lms_credentials.any?

    lms_credentials.each do |credential|
      return true if credential.expire_time && Time.zone.now + buffer_minutes.minutes > credential.expire_time
    end

    false
  end

  # Get active token or refresh if needed
  def ensure_fresh_token
    return nil unless lms_credentials.any?

    credential = lms_credentials.first

    if token_expires_soon?
      # Call the refresh token method from SessionController
      SessionController.new.send(:refresh_user_token, self)
    end

    credential.token
  end
end
