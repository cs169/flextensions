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

      Rails.logger.info "Course ID: #{course.id}"
      course_to_lms = CourseToLms.find_or_create_by(course_id: course.id, lms_id: 1) do |ctl|
        ctl.external_course_id = course_data['id']
      end

      assignments = fetch_assignments(course_data['id'], token)
      assignments.each do |assignment_data|
        Assignment.find_or_create_by(course_to_lms_id: course_to_lms.id) do |assignment|
          assignment.name = assignment_data['name']
          Rails.logger.info "Assignment Name: #{assignment.name}"
        end
      end
      

      # Create a new UserToCourse record if it doesn't already exist
      UserToCourse.find_or_create_by(user_id: user.id, course_id: course.id) do |user_to_course|
        user_to_course.role = 'teacher'
      end
    end

    redirect_to courses_path, notice: 'Selected courses have been imported successfully.'
  end

  def delete_all
    user = User.find_by(canvas_uid: session[:user_id])
    if user.nil?
      redirect_to root_path, alert: 'Please log in to access this page.'
      return
    end

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
