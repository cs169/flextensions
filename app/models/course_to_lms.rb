class CourseToLms < ApplicationRecord

  # Associations
  belongs_to :course
  belongs_to :lms

  # Validations
  validates :course_id, presence: true
  validates :lms_id, presence: true

end