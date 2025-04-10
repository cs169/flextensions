class Course < ApplicationRecord
  # Associations
  has_many :course_to_lmss
  has_many :lmss, through: :course_to_lmss
  has_many :user_to_courses
  has_many :users, through: :user_to_courses

  # Validations
  validates :course_name, presence: true

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
    course = find_or_create_course(course_data)
    course_to_lms = find_or_create_course_to_lms(course, course_data)
    sync_assignments(course_to_lms, token)
    course.sync_enrollments_from_canvas(token)
    course
  end

  # Find or create the course
  def self.find_or_create_course(course_data)
    find_or_create_by(canvas_id: course_data['id']) do |c|
      c.course_name = course_data['name']
      c.course_code = course_data['course_code']
    end
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
    assignments = course_to_lms.fetch_assignments(token)
    assignments.each do |assignment_data|
      sync_assignment(course_to_lms, assignment_data)
    end
  end

  # Sync a single assignment
  def self.sync_assignment(course_to_lms, assignment_data)
    Assignment.find_or_create_by(course_to_lms_id: course_to_lms.id, external_assignment_id: assignment_data['id']) do |assignment|
      assignment.name = assignment_data['name']
      assignment.due_date = DateTime.parse(assignment_data['due_at']) if assignment_data['due_at'].present?
      assignment.late_due_date = DateTime.parse(assignment_data['due_at']) if assignment_data['due_at'].present? && (assignment.late_due_date.nil? || assignment.late_due_date < DateTime.parse(assignment_data['due_at']))
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

    users_data.each do |user_data|
      # Create or find the User model
      user = User.find_or_create_by(canvas_uid: user_data['id']) do |u|
        u.name = user_data['name']
        u.email = user_data['email'] # Assuming login_id is the email
      end

      # Use the associate_user_with_course method to create the UserToCourse record
      UserToCourse.find_or_create_by(user_id: user.id, course_id: id, role: role)
    end
  end

  def sync_enrollments_from_canvas(token)
    sync_users_from_canvas(token, 'student')
    sync_users_from_canvas(token, 'teacher')
    sync_users_from_canvas(token, 'ta')
  end
end
