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

  # Helper function for the controller
  # Note: This is too close to the association, course_to_lmss
  def course_to_lms(lms_id = 1)
    CourseToLms.find_by(course_id: id, lms_id: lms_id)
  end

  def user_role(user)
    roles = UserToCourse.where(user_id: user.id, course_id: id).pluck(:role)
    return 'instructor' if roles.include?('teacher') || roles.include?('ta')
    return 'student' if roles.include?('student')

    nil
  end

  def assignments
    Assignment.joins(:course_to_lms).where(course_to_lms: { course_id: id })
  end

  def destroy_associations
    assignments.destroy_all
    course_to_lmss.destroy_all
    user_to_courses.destroy_all
    form_setting.destroy if form_setting
    course_settings.destroy if course_settings
  end

  # Fetch courses from Canvas API
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
        auto_approve_dsp_days: 0,
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

    sync_assignments(course_to_lms, token)
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

  # Sync assignments for the course
  def self.sync_assignments(course_to_lms, token)
    # Fetch assignments from Canvas
    assignments = course_to_lms.get_all_canvas_assignments(token)

    # Keep track of external assignment IDs from Canvas
    external_assignment_ids = assignments.pluck('id')

    # Sync or update assignments
    assignments.each do |assignment_data|
      sync_assignment(course_to_lms, assignment_data)
    end

    # Delete assignments that no longer exist in Canvas
    Assignment.where(course_to_lms_id: course_to_lms.id)
              .where.not(external_assignment_id: external_assignment_ids)
              .destroy_all
  end

  # Sync a single assignment
  def self.sync_assignment(course_to_lms, assignment_data)
    assignment = Assignment.find_or_initialize_by(course_to_lms_id: course_to_lms.id, external_assignment_id: assignment_data['id'])
    assignment.name = assignment_data['name']

    # Extract due_at and lock_at dates
    assignment.due_date = extract_date_field(assignment_data, 'due_at')
    assignment.late_due_date = extract_date_field(assignment_data, 'lock_at')

    assignment.save!
  end

  # Helper method to extract dates from assignment data
  def self.extract_date_field(assignment_data, field_name)
    if assignment_data['base_date'] && assignment_data['base_date'][field_name].present?
      DateTime.parse(assignment_data['base_date'][field_name])
    elsif assignment_data[field_name].present?
      DateTime.parse(assignment_data[field_name])
    end
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
