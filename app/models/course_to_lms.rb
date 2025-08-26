# == Schema Information
#
# Table name: course_to_lmss
#
#  id                     :bigint           not null, primary key
#  recent_assignment_sync :jsonb
#  recent_roster_sync     :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  course_id              :bigint
#  external_course_id     :string
#  lms_id                 :bigint
#
# Indexes
#
#  index_course_to_lmss_on_course_id  (course_id)
#  index_course_to_lmss_on_lms_id     (lms_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (lms_id => lmss.id)
#
class CourseToLms < ApplicationRecord
  # Associations
  belongs_to :course
  belongs_to :lms

  # Fetch assignments from Canvas API
  def get_all_canvas_assignments(user)
    CanvasFacade.for_user(user).get_all_assignments(external_course_id)
  rescue StandardError => e
    Rails.logger.error "Failed to fetch assignments: #{e.message}"
    []
  end
end
