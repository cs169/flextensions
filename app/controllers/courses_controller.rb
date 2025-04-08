class CoursesController < ApplicationController
  before_action :authenticate_user

  def index
    return if @user.nil?

    # Fetch UserToCourse records where the user is a teacher or TA
    @teacher_courses = UserToCourse.includes(:course).where(user: @user, role: %w[teacher ta])
  end

  def show
    @side_nav = 'show'
    if @user.nil?
      Rails.logger.info 'User not found in session'
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
    if @user.nil?
      Rails.logger.info 'User not found in session'
      return
    end

    token = @user.canvas_token
    @courses = Course.fetch_courses(token)
    if @courses.empty?
      Rails.logger.info 'No courses found.'
      flash[:alert] = 'No courses found.'
    end

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
    if @user.nil?
      Rails.logger.info 'User not found in session'
      return
    end

    @course = Course.find_by(id: params[:id])
    return if @course

    flash[:alert] = 'Course not found.'
    redirect_to courses_path and return
  end

  def requests
    @side_nav = 'requests'
    if @user.nil?
      Rails.logger.info 'User not found in session'
      return
    end

    @course = Course.find_by(id: params[:id])
    return if @course

    flash[:alert] = 'Course not found.'
    redirect_to courses_path and return
  end

  def create
    return if @user.nil?

    token = @user.canvas_token
    courses = Course.fetch_courses(token)

    teacher_roles = %w[teacher ta]
    courses_teacher = courses.select do |course|
      course['enrollments'].any? { |enrollment| teacher_roles.include?(enrollment['type']) }
    end

    selected_course_ids = params[:courses] || []
    selected_courses = courses_teacher.select { |course| selected_course_ids.include?(course['id'].to_s) }

    selected_courses.each do |course_data|
      Course.create_or_update_from_canvas(course_data, token, @user)
    end

    redirect_to courses_path, notice: 'Selected courses and their assignments have been imported successfully.'
  end

  def sync_assignments
    if @user.nil?
      render json: { error: 'Please log in to access this page.' }, status: :unauthorized
      return
    end

    @course = Course.find_by(id: params[:id])
    if @course.nil?
      render json: { error: 'Course not found.' }, status: :not_found
      return
    end

    course_to_lms = CourseToLms.find_by(course_id: @course.id, lms_id: 1)
    if course_to_lms.nil?
      render json: { error: 'No LMS data found for this course.' }, status: :not_found
      return
    end

    # Fetch assignments using the CourseToLms model
    token = @user.canvas_token
    assignments = course_to_lms.fetch_assignments(token)

    # Create or update assignments
    assignments.each do |assignment_data|
      assignment = Assignment.find_or_initialize_by(course_to_lms_id: course_to_lms.id, external_assignment_id: assignment_data['id'])
      assignment.name = assignment_data['name']
      assignment.due_date = DateTime.parse(assignment_data['due_at']) if assignment_data['due_at'].present?
      assignment.save!
    end

    render json: { message: 'Assignments synced successfully.' }, status: :ok
  end

  # ONLY USE THIS FOR TESTING PURPOSES
  def delete_all
    return if @user.nil?

    # Delete all assignments associated with the user's courses
    Assignment.where(course_to_lms_id: CourseToLms.where(course_id: Course.joins(:user_to_courses).where(user_to_courses: { user_id: @user.id }).select(:id)).select(:id)).destroy_all

    # Delete all CourseToLms records associated with the user's courses
    CourseToLms.where(course_id: Course.joins(:user_to_courses).where(user_to_courses: { user_id: @user.id }).select(:id)).destroy_all

    # Delete all UserToCourse records for the user
    UserToCourse.where(user_id: @user.id).destroy_all

    # Delete orphaned courses (courses with no associated UserToCourse records)
    Course.where.missing(:user_to_courses).destroy_all

    redirect_to courses_path, notice: 'All your courses and associations have been deleted successfully.'
  end

  private

  def authenticate_user
    @user = User.find_by(canvas_uid: session[:user_id])
    return unless @user.nil?

    redirect_to root_path, alert: 'Please log in to access this page.'
  end

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
