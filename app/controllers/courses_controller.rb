class CoursesController < ApplicationController
  before_action :authenticate_user
  before_action :set_course, only: %i[show edit sync_assignments sync_enrollments enrollments delete]
  before_action :set_pending_request_count
  before_action :determine_user_role

  def index
    @teacher_courses = UserToCourse.includes(:course).where(user: @user, role: %w[teacher ta])

    # Only show courses to students if extensions are enabled at the course level
    student_courses = UserToCourse.includes(course: :course_settings).where(user: @user, role: 'student')
    @student_courses = student_courses.select do |utc|
      course_settings = utc.course.course_settings
      course_settings.nil? || course_settings.enable_extensions
    end
  end

  def show
    @side_nav = 'show'
    return redirect_to courses_path, alert: 'Course not found.' unless @course

    @course.regenerate_readonly_api_token_if_blank

    course_to_lms = @course.course_to_lms(1)
    return redirect_to courses_path, alert: 'No LMS data found for this course.' unless course_to_lms

    if @role == 'student'
      course_settings = @course.course_settings
      return redirect_to courses_path, alert: 'Extensions are not enabled for this course.' if course_settings && !course_settings.enable_extensions
    end

    @assignments = if @role == 'student'
      Assignment.where(course_to_lms_id: course_to_lms.id, enabled: true).order(:name)
    else
      Assignment.where(course_to_lms_id: course_to_lms.id).order(:name)
    end
    render_role_based_view
  end

  def new
    token = @user.lms_credentials.first.token
    @courses = Course.fetch_courses(token)
    flash[:alert] = 'No courses found.' if @courses.empty?

    teacher_enrollment_types = %w[teacher ta]
    # TODO: Add spec for when a course is created, but the user is not enrolled in it.
    # TODO: Why do some courses have empty enrollments?
    existing_canvas_ids = @user.courses.pluck(:canvas_id)
    @courses_teacher = filter_courses(@courses, teacher_enrollment_types, existing_canvas_ids)
    @courses_student = filter_courses(@courses, [ 'student' ], existing_canvas_ids)
  end

  def edit
    @side_nav = 'edit'
    redirect_to course_path(@course.id), alert: 'You do not have access to this page.' unless @role == 'instructor'
  end

  def create
    token = @user.lms_credentials.first.token
    filter_courses(Course.fetch_courses(token), %w[teacher ta])
      .select { |c| params[:courses]&.include?(c['id'].to_s) }
      .each { |course_api| Course.create_or_update_from_canvas(course_api, token, @user) }
    redirect_to courses_path, notice: 'Selected courses and their assignments have been imported successfully.'
  end

  def sync_assignments
    return render json: { error: 'Course not found.' }, status: :not_found unless @course

    @course.sync_assignments(@user)
    render json: { message: 'Assignments synced successfully.' }, status: :ok
  end

  def sync_enrollments
    return render json: { error: 'Course not found.' }, status: :not_found unless @course

    @course.sync_all_enrollments_from_canvas(@user.id)
    render json: { message: 'Users synced successfully.' }, status: :ok
  end

  def enrollments
    @side_nav = 'enrollments'
    return redirect_to courses_path, alert: 'You do not have access to this page.' unless @role == 'instructor'

    @enrollments = @course.user_to_courses.includes(:user)
  end

  def delete
    return redirect_to courses_path, alert: 'You do not have access to this page.' unless @role == 'instructor'
    return redirect_to courses_path, alert: 'Extensions are enabled for this course.' if @course.course_settings&.enable_extensions

    assignments = Assignment.where(course_to_lms_id: CourseToLms.where(course_id: @course.id).select(:id))
    Extension.where(assignment_id: assignments.select(:id)).destroy_all
    assignments.destroy_all
    CourseToLms.where(course_id: @course.id).destroy_all
    UserToCourse.where(course_id: @course.id).destroy_all
    Request.where(course_id: @course.id).destroy_all
    CourseSettings.where(course_id: @course.id).destroy_all
    FormSetting.where(course_id: @course.id).destroy_all
    Course.where.missing(:user_to_courses).destroy_all

    redirect_to courses_path, notice: 'Course deleted successfully.'
  end

  private

  # TODO: Move to app controller.
  def authenticate_user
    @user = User.find_by(canvas_uid: session[:user_id])
    redirect_to root_path, alert: 'Please log in to access this page.' unless @user
  end

  def set_course
    @course = Course.find_by(id: params[:id])
    redirect_to courses_path, alert: 'Course not found.' unless @course
  end

  def determine_user_role
    @role = @course&.user_role(@user)
  end

  # TODO: This should be moved to the Canvas Facade
  def filter_courses(courses, roles, exclude_ids = [])
    missing_enrollments = courses.select { |course| course['enrollments'].blank? }
    Rails.logger.warn("Canvas API by #{current_user.id}: Courses with missing enrollments: #{missing_enrollments.pluck('id').join(', ')}") unless missing_enrollments.empty?

    courses = courses - missing_enrollments - courses.select { |course| exclude_ids.include?(course['id'].to_s) }
    return [] if courses.empty?

    courses.select { |course| course['enrollments'].any? { |e| roles.include?(e['type']) } }
  end

  def course_data_for_sync
    { 'id' => @course.canvas_id, 'name' => @course.course_name, 'course_code' => @course.course_code }
  end
end
