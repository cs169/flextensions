class Course < ApplicationRecord
  # Associations
  has_many :course_to_lmss
  has_many :lmss, through: :course_to_lmss
  has_many :user_to_courses
  has_many :users, through: :user_to_courses
  has_one :form_setting, dependent: :destroy
  has_one :course_settings, dependent: :destroy
  has_many :requests, dependent: :destroy

  # Validations
  validates :course_name, presence: true

  # Helper function for the controller
  def course_to_lms(lms_id = 1)
    CourseToLms.find_by(course_id: id, lms_id: lms_id)
  end

  def user_role(user)
    roles = UserToCourse.where(user_id: user.id, course_id: id).pluck(:role)
    return 'instructor' if roles.include?('teacher') || roles.include?('ta')
    return 'student' if roles.include?('student')

    nil
  end

  # Fetch courses from Canvas API
  def self.fetch_courses(token)
    response = Faraday.get("#{ENV.fetch('CANVAS_URL', nil)}/api/v1/courses") do |req|
      req.headers['Authorization'] = "Bearer #{token}"
      req.headers['Content-Type'] = 'application/json'
      req.params['include[]'] = 'enrollment_type'
    end

    if response.success?
      JSON.parse(response.body)
    else
      Rails.logger.error "Failed to fetch courses from Canvas: #{response.status} - #{response.body}"
      []
    end
  end

  # Create or find a course and its associated CourseToLms and assignments
  def self.create_or_update_from_canvas(course_data, token, _user)
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
        enable_gradescope: false,
        gradescope_course_url: nil,
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
    course.sync_enrollments_from_canvas(token)
    course
  end

  # Find or create the course
  def self.find_or_create_course(course_data, token)
    canvas_facade = CanvasFacade.new(token)
    response = canvas_facade.get_course(course_data['id'])

    if response.success?
      course = find_or_initialize_by(canvas_id: course_data['id'])
      response_data = JSON.parse(response.body)
      course.course_name = response_data['name']
      course.course_code = response_data['course_code']
      course.save!
    end
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
    assignments = course_to_lms.fetch_assignments(token)

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

  # Fetch users for a course from Canvas API
  def fetch_users_from_canvas(token, enrollment_type = nil)
    url = "#{ENV.fetch('CANVAS_URL')}/api/v1/courses/#{canvas_id}/users"
    response = Faraday.get(url) do |req|
      req.headers['Authorization'] = "Bearer #{token}"
      req.headers['Content-Type'] = 'application/json'
      req.params['enrollment_type'] = enrollment_type if enrollment_type.present?
    end

    if response.success?
      JSON.parse(response.body)
    else
      Rails.logger.error "Failed to fetch users from Canvas: #{response.status} - #{response.body}"
      []
    end
  end

  # Fetch users for a course and create/find their User and UserToCourse records
  def sync_users_from_canvas(token, role)
    # Fetch all users for the course from Canvas
    users_data = fetch_users_from_canvas(token, role)

    # Extract the Canvas user IDs from the fetched data
    current_canvas_user_ids = users_data.pluck('id')

    # Find all UserToCourse records for this course and role
    existing_user_to_courses = UserToCourse.where(course_id: id, role: role)

    # Delete UserToCourse records for users no longer in the course
    existing_user_to_courses.each do |user_to_course|
      user_to_course.destroy unless current_canvas_user_ids.include?(user_to_course.user.canvas_uid)
    end

    # Create or update User and UserToCourse records for current users
    users_data.each do |user_data|
      # this line skips importing a user if the api doesn't return their email
      # one case this is happening if the user was invited to the course but hasn't accepted
      next if user_data['email'].blank?

      # Create or find the User model
      user = User.find_or_create_by(canvas_uid: user_data['id']) do |u|
        u.name = user_data['name']
        u.email = user_data['email'] # Assuming login_id is the email
      end
      user.student_id = user_data['sis_user_id']
      user.save!

      # Create or update the UserToCourse record
      UserToCourse.find_or_create_by(user_id: user.id, course_id: id, role: role)
    end
  end

  def sync_enrollments_from_canvas(token)
    sync_users_from_canvas(token, 'student')
    sync_users_from_canvas(token, 'teacher')
    sync_users_from_canvas(token, 'ta')
  end
end
