# == Schema Information
#
# Table name: courses
#
#  id                 :bigint           not null, primary key
#  course_code        :string
#  course_name        :string
#  readonly_api_token :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  canvas_id          :string
#
# Indexes
#
#  index_courses_on_canvas_id           (canvas_id) UNIQUE
#  index_courses_on_readonly_api_token  (readonly_api_token) UNIQUE
#
class Course < ApplicationRecord
  has_secure_token :readonly_api_token

  after_create :regenerate_readonly_api_token_if_blank
  # TODO: after_initialize :build_course_settings_if_necessary

  # Associations
  has_many :course_to_lmss, dependent: :destroy
  has_many :lmss, through: :course_to_lmss
  has_many :user_to_courses, dependent: :destroy
  has_one :form_setting, dependent: :destroy
  has_one :course_settings, dependent: :destroy
  has_many :requests, dependent: :destroy

  has_many :users, through: :user_to_courses

  # Validations
  validates :course_name, presence: true
  # validate :ensure_course_settings

  # Note: This is too close to the association, course_to_lmss
  def course_to_lms(lms_id = 1)
    CourseToLms.find_by(course_id: id, lms_id: lms_id)
  end

  # TODO: Replace this with staff_role?(user) or student_role?(user)
  # Or is user.staff_role?(course) or user.student_role?(course) better?
  def user_role(user)
    roles = UserToCourse.where(user_id: user.id, course_id: id).pluck(:role)
    return 'instructor' if roles.include?('teacher') || roles.include?('ta')
    return 'student' if roles.include?('student')

    nil
  end

  # TODO: Add specs for these 4 simple methods
  def assignments
    Assignment.joins(:course_to_lms).where(course_to_lms: { course_id: id })
  end

  def students
    user_to_courses.where(role: 'student').map(&:user)
  end

  def instructors
    user_to_courses.where(role: 'teacher').map(&:user)
  end

  def staff_users
    user_to_courses.where(role: UserToCourse.staff_roles).map(&:user)
  end

  def destroy_associations
    assignments.destroy_all
    course_to_lmss.destroy_all
    user_to_courses.destroy_all
    form_setting.destroy if form_setting
    course_settings.destroy if course_settings
  end

  # Find the first staff user who has a Canvas Token that can be used
  # to post requests to Canvas.
  def staff_user_for_auto_approval
    user_to_courses.where(role: UserToCourse.staff_roles).first&.user
  end

  # Fetch courses from Canvas API
  # TODO: This belongs elsewhere.
  def self.fetch_courses(token)
    all_courses = CanvasFacade.new(token).get_all_courses

    if all_courses.is_a?(Array)
      all_courses
    else
      Rails.logger.error 'Failed to fetch courses'
      []
    end
  end

  # Create or find a course and its associated CourseToLms and assignments
  def self.create_or_update_from_canvas(course_data, token, user)
    course = find_or_create_course(course_data, token)
    course_to_lms = find_or_create_course_to_lms(course, course_data)

    # Creating a 1 to 1 form_settings record to course since the instructor is only meant to update form_settings
    unless course.form_setting
      form_setting = course.build_form_setting(
        documentation_desc: <<~DESC,
          Please provide links to any additional details if relevant.
        DESC
        documentation_disp: 'hidden',
        custom_q1_disp: 'hidden',
        custom_q2_disp: 'hidden'
      )
      form_setting.save!
    end

    # Create a 1-to-1 course_settings record if it doesn't exist
    unless course.course_settings
      course_settings = course.build_course_settings(
        enable_extensions: false,
        auto_approve_days: 0,
        auto_approve_extended_request_days: 0,
        max_auto_approve: 0,
        enable_emails: false,
        reply_email: nil,
        email_subject: 'Extension Request Status: {{status}} - {{course_code}}',
        email_template: <<~TEMPLATE
          Dear {{student_name}},

          Your extension request for {{assignment_name}} in {{course_name}} ({{course_code}}) has been {{status}}.

          Extension Details:
          - Original Due Date: {{original_due_date}}
          - New Due Date: {{new_due_date}}
          - Extension Days: {{extension_days}}

          If you have any questions, please contact the course staff.

          Best regards,
          {{course_name}} Staff
        TEMPLATE
      )
      course_settings.save!
    end

    # TODO: Consider disabling these if performance becomes an issue
    course.sync_assignments(user)
    course.sync_all_enrollments_from_canvas(user.id)
    course
  end

  # Find or create the course
  def self.find_or_create_course(course_data, token)
    canvas_facade = CanvasFacade.new(token)
    response = canvas_facade.get_course(course_data['id'])

    if response.nil? || !response.success?
      Rails.logger.error "Failed to fetch course: #{response.status} - #{response.body}"
      # TODO: Raise error to user?
      return nil
    end

    course = find_or_initialize_by(canvas_id: course_data['id'])
    response_data = JSON.parse(response.body)
    course.course_name = response_data['name']
    course.course_code = response_data['course_code']
    course.save!
    course
  end

  # Find or create the CourseToLms record
  def self.find_or_create_course_to_lms(course, course_data)
    CourseToLms.find_or_initialize_by(course_id: course.id, lms_id: 1).tap do |course_to_lms|
      course_to_lms.external_course_id = course_data['id']
      course_to_lms.save!
    end
  end

  def sync_assignments(sync_user)
    # Explicitly look for Canvas links.
    # TODO: In the future, we will need to adapt this to work with Gradescope.
    course_to_lms = self.course_to_lms(1)
    return unless course_to_lms

    SyncAllCourseAssignmentsJob.perform_now(course_to_lms.id, sync_user.id)
  end

  # Fetch users for a course and create/find their User and UserToCourse records
  # TODO: This may need to become a background job
  def sync_users_from_canvas(user, roles = [ 'student' ])
    SyncUsersFromCanvasJob.perform_now(id, user, roles)
  end

  def sync_all_enrollments_from_canvas(user)
    sync_users_from_canvas(user, [ 'teacher', 'ta', 'student' ])
  end

  def regenerate_readonly_api_token_if_blank
    regenerate_readonly_api_token if readonly_api_token.blank?
  end
end
