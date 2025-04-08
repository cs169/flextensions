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
  def self.create_or_update_from_canvas(course_data, token, user)
    course = find_or_create_by(canvas_id: course_data['id']) do |c|
      c.course_name = course_data['name']
      c.course_code = course_data['course_code']
    end

    course_to_lms = CourseToLms.find_or_initialize_by(course_id: course.id, lms_id: 1)
    course_to_lms.external_course_id = course_data['id']
    course_to_lms.save!

    assignments = course_to_lms.fetch_assignments(token)
    assignments.each do |assignment_data|
      Assignment.find_or_create_by(course_to_lms_id: course_to_lms.id, external_assignment_id: assignment_data['id']) do |assignment|
        assignment.name = assignment_data['name']
        assignment.due_date = DateTime.parse(assignment_data['due_at']) if assignment_data['due_at'].present?
      end
    end

    UserToCourse.find_or_create_by(user_id: user.id, course_id: course.id) do |user_to_course|
      user_to_course.role = 'teacher'
    end

    course
  end
end
