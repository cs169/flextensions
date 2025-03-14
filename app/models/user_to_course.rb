class UserToCourse < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :course

  # Validations
  validates :role, presence: true
end
