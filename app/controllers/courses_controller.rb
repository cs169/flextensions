class CoursesController < ApplicationController
  before_action :authenticate_user

  def index
    # Temp Code for making an LMS
    Lms.find_or_create_by(id: 1) do |lms|
      lms.lms_name = 'Canvas'
      lms.use_auth_token = true
    end

    # Fetch UserToCourse records where the user is a teacher or TA
    @teacher_courses = UserToCourse.includes(:course).where(user: @user, role: %w[teacher ta])
    # Fetch UserToCourse records where the user is a student
    @student_courses = UserToCourse.includes(:course).where(user: @user, role: 'student')
  end

  def show
    @side_nav = 'show'

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

    @role = determine_user_role(@course)
    case @role
    when 'instructor'
      render 'courses/instructor_view'
    when 'student'
      render 'courses/student_view'
    else
      flash[:alert] = 'You do not have access to this course.'
      redirect_to courses_path
    end
  end

  def new
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

    @course = Course.find_by(id: params[:id])
    return if @course
    @role = determine_user_role(@course)

    unless @role == 'instructor'
      flash[:alert] = 'You do not have access to this page.'
      redirect_to courses_path and return
    end

    flash[:alert] = 'Course not found.'
    redirect_to courses_path and return
  end

  def requests
    @side_nav = 'requests'

    @course = Course.find_by(id: params[:id])
    return if @course
    @role = determine_user_role(@course)
    case @role
    when 'instructor'
      render 'courses/instructor_request_view'
    when 'student'
      render 'courses/student_request_view'
    else
      flash[:alert] = 'You do not have access to this course.'
      redirect_to courses_path
    end

    flash[:alert] = 'Course not found.'
    redirect_to courses_path and return
  end

  def create
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
    @course = Course.find_by(id: params[:id])
    if @course.nil?
      render json: { error: 'Course not found.' }, status: :not_found
      return
    end

    # Fetch the Canvas token
    token = @user.canvas_token

    # Use the Course model's create_or_update_from_canvas method
    course_data = {
      'id' => @course.canvas_id,
      'name' => @course.course_name,
      'course_code' => @course.course_code
    }

    # Call the model method to sync assignments
    Course.create_or_update_from_canvas(course_data, token, @user)

    render json: { message: 'Assignments synced successfully.' }, status: :ok
  end

  def sync_enrollments
    @course = Course.find_by(id: params[:id])
    if @course.nil?
      render json: { error: 'Course not found.' }, status: :not_found
      return
    end

    # Fetch the Canvas token
    token = @user.canvas_token

    # Call the sync_users_from_canvas method
    @course.sync_enrollments_from_canvas(token)

    Rails.logger.info "Users synced for course ID: #{@course.id}"
    render json: { message: 'Users synced successfully.' }, status: :ok
  end

  # ONLY USE THIS FOR TESTING PURPOSES
  def delete_all
    # Delete all assignments associated with the user's courses
    Assignment.where(course_to_lms_id: CourseToLms.where(course_id: Course.joins(:user_to_courses).where(user_to_courses: { user_id: @user.id }).select(:id)).select(:id)).destroy_all

    # Delete all CourseToLms records associated with the user's courses
    CourseToLms.where(course_id: Course.joins(:user_to_courses).where(user_to_courses: { user_id: @user.id }).select(:id)).destroy_all

    # Delete all UserToCourse records for the user
    UserToCourse.where(course_id: Course.joins(:user_to_courses).where(user_to_courses: { user_id: @user.id }).select(:id)).destroy_all

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

  def determine_user_role(course)
    roles = UserToCourse.where(user_id: @user.id, course_id: course.id).pluck(:role)
    return 'instructor' if roles.include?('teacher') || roles.include?('ta')
    return 'student' if roles.include?('student')

    nil
  end
end
