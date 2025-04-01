class Course < ApplicationRecord
  # Associations
  has_many :course_to_lmss
  has_many :lmss, through: :course_to_lmss
  has_many :user_to_courses
  has_many :users, through: :user_to_courses

  # Validations
  validates :course_name, presence: true
  #validates :canvas_id, presence: true, uniqueness: true
end
