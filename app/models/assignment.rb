# app/models/assignment.rb
# == Schema Information
#
# Table name: assignments
#
#  id                     :bigint           not null, primary key
#  due_date               :datetime
#  enabled                :boolean          default(FALSE)
#  late_due_date          :datetime
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  course_to_lms_id       :bigint           not null
#  external_assignment_id :string
#
# Foreign Keys
#
#  fk_rails_...  (course_to_lms_id => course_to_lmss.id)
#
class Assignment < ApplicationRecord
  belongs_to :course_to_lms
  has_many :requests, dependent: :destroy

  validates :name, presence: true
  validates :external_assignment_id, presence: true

  validate :enabled_requires_date_present

  # Returns enabled assignments for a specific course
  scope :enabled_for_course, ->(course_to_lms_id) { where(course_to_lms_id: course_to_lms_id, enabled: true) }

  # Check if there's a pending request for this assignment by a specific user
  def has_pending_request_for_user?(user, course)
    requests.exists?(user: user, course: course, status: 'pending')
  end

  def enabled_requires_date_present
    errors.add(:due_date, 'must be present if assignment is enabled') if enabled && due_date.blank?
  end
end
