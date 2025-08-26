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
    role == 'teacher' || role == 'leadta'
  end

  def student?
    role == 'student'
  end

  def self.roles
    [ 'student' ] + UserToCourse.staff_roles
  end

  def self.staff_roles
    %w[teacher ta leadta]
  end
end
