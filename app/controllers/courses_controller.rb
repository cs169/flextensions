class CoursesController < ApplicationController
  before_action :authenticate_user
  before_action :set_course, only: %i[show edit form requests sync_assignments sync_enrollments]
  before_action :determine_user_role

  # Define coursese variables for teacher role and student role separately.
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

    return if @course.nil?

    @course.reload
    # Find the CourseToLms record for the course with lms_id of 1
    course_to_lms = @course.course_to_lms(1)
    if course_to_lms.nil?
      flash[:alert] = 'No LMS data found for this course.'
      Rails.logger.info "No LMS data found for course ID: #{@course.id}"
      redirect_to courses_path
      return
    end

    # Fetch assignments associated with the CourseToLms
    @assignments = Assignment.where(course_to_lms_id: course_to_lms.id)

    # might want to create a convention and factor out this case statement
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
    existing_canvas_ids = Course.pluck(:canvas_id) # Fetch all existing canvas_ids from the database

    @courses_teacher = @courses.select do |course|
      course['enrollments'].any? { |enrollment| teacher_roles.include?(enrollment['type']) } &&
        !existing_canvas_ids.include?(course['id'].to_s) # Exclude courses that already exist
    end

    @courses_student = @courses.select do |course|
      course['enrollments'].any? { |enrollment| enrollment['type'] == 'student' }
    end
  end

  def edit
    @side_nav = 'edit'
    unless @role == 'instructor'
      flash[:alert] = 'You do not have access to this page.'
      redirect_to course_path(@course.id) and return
    end
    nil if @course.nil?
  end

  def requests
    @side_nav = 'requests'
    # might want to create a convention and factor out this case statement
    case @role
    when 'instructor'
      render 'courses/instructor_request_view'
    when 'student'
      render 'courses/student_request_view'
    else
      flash[:alert] = 'You do not have access to this course.'
      redirect_to courses_path
    end
    nil if @course.nil?
  end

  # this is for requests/new (might change the name later)
  def form
    @side_nav = 'form'
    unless @role == 'student'
      flash[:alert] = 'You do not have access to this page.'
      redirect_to course_path(@course.id) and return
    end
    # Find the CourseToLms record for the course with lms_id of 1
    course_to_lms = @course.course_to_lms(1)
    if course_to_lms.nil?
      flash[:alert] = 'No LMS data found for this course.'
      Rails.logger.info "No LMS data found for course ID: #{@course.id}"
      redirect_to courses_path
      return
    end
    # Fetch assignments associated with the CourseToLms
    @assignments = Assignment.where(course_to_lms_id: course_to_lms.id)
    @selected_assignment = Assignment.find_by(id: params[:assignment_id]) if params[:assignment_id]
  end

  def new_request
    redirect_to course_extension_form_path(params[:course_id], assignment_id: params[:assignment_id])
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

  def set_course
    @course = Course.find_by(id: params[:id])
    return if @course

    flash[:alert] = 'Course not found.'
    redirect_to courses_path
  end

  def determine_user_role
    return unless @course && @user

    @role = @course.user_role(@user)
  end
end
