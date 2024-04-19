# app/models/course_to_lms.rb
class CourseToLms < ApplicationRecord
    # Association with Course and Lms
    belongs_to :course
    belongs_to :lms
  
    # You can add validations here if needed, for example:
    validates :course_id, presence: true
    validates :lms_id, presence: true
  end
  