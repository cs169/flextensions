class CourseSetting < ApplicationRecord
  belongs_to :course

  validates :course_id, presence: true
  validates :enable_student_requests, inclusion: { in: [true, false] }
  validates :enable_emails, inclusion: { in: [true, false] }, allow_nil: true
  validates :auto_approve_days, numericality: { only_integer: true, greater_than: 0, allow_nil: true }
  validates :auto_approve_dsp_days, numericality: { only_integer: true, greater_than: 0, allow_nil: true }
  validates :max_auto_approve, numericality: { only_integer: true, greater_than: 0, allow_nil: true }
end
