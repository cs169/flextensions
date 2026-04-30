# == Schema Information
#
# Table name: user_to_courses
#
#  id                      :bigint           not null, primary key
#  allow_extended_requests :boolean          default(FALSE), not null
#  removed                 :boolean          default(FALSE), not null
#  role                    :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  course_id               :bigint
#  user_id                 :bigint
#
# Indexes
#
#  index_user_to_courses_on_course_id  (course_id)
#  index_user_to_courses_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (user_id => users.id)
#
# TODO: In the future we should name this CourseEnrollment
class UserToCourse < ApplicationRecord
  STUDENT_ROLE = 'student'.freeze
  TEACHER_ROLE = 'teacher'.freeze
  TA_ROLE = 'ta'.freeze
  LEAD_TA_ROLE = 'leadta'.freeze
  STAFF_ROLES = [ TEACHER_ROLE, TA_ROLE, LEAD_TA_ROLE ].freeze
  COURSE_ADMIN_ROLES = [ TEACHER_ROLE, LEAD_TA_ROLE ].freeze
  ROLE_LABELS = {
    LEAD_TA_ROLE => 'Lead TA'
  }.freeze

  # Associations
  belongs_to :user
  belongs_to :course

  # Validations
  # NOTE: Validations are skipped when a User is created by SyncUsersFromCanvasJob
  # You should update that job if these validations become complex.
  # In the meantime, we can trust that the data coming from Canvas is valid.
  validates :role, presence: true


  def staff?
    UserToCourse.staff_roles.include?(role)
  end

  def course_admin?
    UserToCourse.course_admin_roles.include?(role)
  end

  def student?
    role == STUDENT_ROLE
  end

  def display_role
    UserToCourse.display_role(role)
  end

  def self.roles
    [ STUDENT_ROLE ] + UserToCourse.staff_roles
  end

  def self.staff_roles
    STAFF_ROLES
  end

  def self.course_admin_roles
    COURSE_ADMIN_ROLES
  end

  def self.normalize_role(role)
    role.to_s.downcase.gsub(/[^a-z]/, '')
  end

  def self.role_from_canvas_enrollment(enrollment)
    return nil unless enrollment

    normalized_role = normalize_role(enrollment['role'] || enrollment[:role])
    return LEAD_TA_ROLE if normalized_role == LEAD_TA_ROLE

    normalized_type = normalize_role(enrollment['type'] || enrollment[:type])
    roles.include?(normalized_type) ? normalized_type : nil
  end

  def self.staff_enrollment?(enrollment)
    staff_roles.include?(role_from_canvas_enrollment(enrollment))
  end

  def self.display_role(role)
    ROLE_LABELS.fetch(role.to_s, role.to_s.capitalize)
  end
end
