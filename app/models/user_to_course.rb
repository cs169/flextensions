class UserToCourse < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :course

  # Validations
  validates :user_id, presence: true
  validates :course_id, presence: true
  validates :role, presence: true
end
