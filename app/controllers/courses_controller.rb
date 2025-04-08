class CoursesController < ApplicationController
  def index
    user = User.find_by(canvas_uid: session[:user_id])
    if user.nil?
      redirect_to root_path, alert: 'Please log in to access this page.'
      return
    end

    # Fetch UserToCourse records where the user is a teacher or TA
    @teacher_courses = UserToCourse.includes(:course).where(user: user, role: %w[teacher ta])
  end

  def show
    @side_nav = 'show'
    user = User.find_by(canvas_uid: session[:user_id])
    if user.nil?
      Rails.logger.info 'User not found in session'
      redirect_to root_path, alert: 'Please log in to access this page.'
      return
    end

    @course = Course.find_by(id: params[:id])
    if @course.nil?
      flash[:alert] = 'Course not found.'
      redirect_to courses_path
      return
    end

    @course.reload
    # Find the CourseToLms record for the course with lms_id of 1
    course_to_lms = CourseToLms.find_by(course_id: @course.id, lms_id: 1)
    if course_to_lms.nil?
      flash[:alert] = 'No LMS data found for this course.'
      Rails.logger.info "No LMS data found for course ID: #{@course.id}"
      redirect_to courses_path
      return
    end

    # Fetch assignments associated with the CourseToLms
    @assignments = Assignment.where(course_to_lms_id: course_to_lms.id)
  end

  def new
    user = User.find_by(canvas_uid: session[:user_id])
    if user.nil?
      Rails.logger.info 'User not found in session'
      redirect_to root_path, alert: 'Please log in to access this page.'
      return
    end
    token = user.canvas_token
    @courses = fetch_courses(token)
    if @courses.empty?
      Rails.logger.info 'No courses found.'
      flash[:alert] = 'No courses found.'
    end
    # Rails.logger.info "Courses: #{@courses}"
    teacher_roles = %w[teacher ta]
    @courses_teacher = @courses.select do |course|
      course['enrollments'].any? { |enrollment| teacher_roles.include?(enrollment['type']) }
    end

    @courses_student = @courses.select do |course|
      course['enrollments'].any? { |enrollment| enrollment['type'] == 'student' }
    end
  end

  def edit
    @side_nav = 'edit'
    user = User.find_by(canvas_uid: session[:user_id])
    if user.nil?
      Rails.logger.info 'User not found in session'
      redirect_to root_path, alert: 'Please log in to access this page.'
      return
    end

    @course = Course.find_by(id: params[:id])
    return if @course

    flash[:alert] = 'Course not found.'
    redirect_to courses_path and return
  end

  def requests
    @side_nav = 'requests'
    user = User.find_by(canvas_uid: session[:user_id])
    if user.nil?
      Rails.logger.info 'User not found in session'
      redirect_to root_path, alert: 'Please log in to access this page.'
      return
    end

    @course = Course.find_by(id: params[:id])
    return if @course

    flash[:alert] = 'Course not found.'
    redirect_to courses_path and return
  end

  def create
    user = User.find_by(canvas_uid: session[:user_id])
    if user.nil?
      redirect_to root_path, alert: 'Please log in to access this page.'
      return
    end

    # Ensure the Lms record exists
    lms = Lms.find_or_create_by(id: 1) do |l|
      l.lms_name = 'Canvas' # Set a default name for the LMS
      l.use_auth_token = true
    end

    # Fetch courses from Canvas
    token = user.canvas_token
    courses = fetch_courses(token)

    # Filter teacher courses
    teacher_roles = %w[teacher ta]
    courses_teacher = courses.select do |course|
      course['enrollments'].any? { |enrollment| teacher_roles.include?(enrollment['type']) }
    end

    # Process selected courses
    selected_course_ids = params[:courses] || []
    selected_courses = courses_teacher.select { |course| selected_course_ids.include?(course['id'].to_s) }

    selected_courses.each do |course_data|
      # Create or find the course in the database
      course = Course.find_or_create_by(canvas_id: course_data['id']) do |c|
        c.course_name = course_data['name']
        c.course_code = course_data['course_code']
      end

      # Create or find the CourseToLms record
      Rails.logger.info "Creating CourseToLms with course_id: #{course.id}, lms_id: 1"
      course_to_lms = CourseToLms.find_or_initialize_by(course_id: course.id, lms_id: 1)
      course_to_lms.external_course_id = course_data['id']
      course_to_lms.save!
      Rails.logger.info "Created CourseToLms: #{course_to_lms.inspect}"

      # Fetch assignments for the course and add them to CourseToLms
      assignments = fetch_assignments(course_data['id'], token)
      assignments.each do |assignment_data|
        Rails.logger.info "assignment_data: #{assignment_data.inspect}"
        Assignment.find_or_create_by(course_to_lms_id: course_to_lms.id, external_assignment_id: assignment_data['id']) do |assignment|
          assignment.name = assignment_data['name']
          assignment.due_date = DateTime.parse(assignment_data['due_at'])
          assignment.late_due_date = DateTime.parse(assignment_data['due_at'])
        end
      end

      # Create a new UserToCourse record if it doesn't already exist
      UserToCourse.find_or_create_by(user_id: user.id, course_id: course.id) do |user_to_course|
        user_to_course.role = 'teacher'
      end
    end

    redirect_to courses_path, notice: 'Selected courses and their assignments have been imported successfully.'
  end


  # ONLY USE THIS FOR TESTING PURPOSES
  def delete_all
    user = User.find_by(canvas_uid: session[:user_id])
    if user.nil?
      redirect_to root_path, alert: 'Please log in to access this page.'
      return
    end

    #Delete all assignments associated with the user's courses
    Assignment.where(course_to_lms_id: CourseToLms.where(course_id: Course.joins(:user_to_courses).where(user_to_courses: { user_id: user.id }).pluck(:id)).pluck(:id)).destroy_all

    # Delete all CourseToLms records associated with the user's courses
    CourseToLms.where(course_id: Course.joins(:user_to_courses).where(user_to_courses: { user_id: user.id }).pluck(:id)).destroy_all

    # Delete all UserToCourse records for the user
    UserToCourse.where(user_id: user.id).destroy_all
    
    # Delete orphaned courses (courses with no associated UserToCourse records)
    Course.where.missing(:user_to_courses).destroy_all

    redirect_to courses_path, notice: 'All your courses and associations have been deleted successfully.'
  end

  private

  def fetch_courses(token)
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

  def fetch_assignments(course_id, token)
    url = "#{ENV.fetch('CANVAS_URL')}/api/v1/courses/#{course_id}/assignments"
    response = Faraday.get(url) do |req|
      req.headers['Authorization'] = "Bearer #{token}"
      req.headers['Content-Type'] = 'application/json'
    end

    if response.success?
      JSON.parse(response.body)
    else
      Rails.logger.error "Failed to fetch assignments: #{response.status} - #{response.body}"
      []
    end
  end
end
