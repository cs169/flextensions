# app/models/assignment.rb
class Assignment < ApplicationRecord
  belongs_to :course_to_lms
  has_many :requests, dependent: :destroy

  validates :name, presence: true
  validates :external_assignment_id, presence: true

  # Returns enabled assignments for a specific course
  scope :enabled_for_course, ->(course_to_lms_id) { where(course_to_lms_id: course_to_lms_id, enabled: true) }
end
