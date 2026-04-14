class CoursesController < ApplicationController
  before_action :authenticate_user
  before_action :set_course, only: %i[show edit sync_assignments sync_enrollments enrollments delete]
  before_action :set_pending_request_count
  before_action :determine_user_role

  def index
    teacher_courses = UserToCourse.includes(:course).where(user: @user, role: %w[teacher ta])
    @teacher_courses_by_semester = group_by_semester(teacher_courses)

    # Only show courses to students if extensions are enabled at the course level
    student_courses = UserToCourse.includes(course: :course_settings).where(user: @user, role: 'student')
    visible_student_courses = student_courses.select do |utc|
      course_settings = utc.course.course_settings
      course_settings.nil? || course_settings.enable_extensions
    end
    @student_courses_by_semester = group_by_semester(visible_student_courses)

    # Keep flat lists for conditional checks in the view
    @teacher_courses = teacher_courses
    @student_courses = visible_student_courses
  end

  def show
    return redirect_to courses_path, alert: 'Course not found.' unless @course
    return redirect_to courses_path, alert: 'No Canvas LMS data found for this course.' unless @course.has_canvas_linked?

    @side_nav = 'show'
    @course.regenerate_readonly_api_token_if_blank

    if @role == 'student'
      course_settings = @course.course_settings
      return redirect_to courses_path, alert: 'Extensions are not enabled for this course.' unless course_settings&.enable_extensions

      @assignments = @course.enabled_assignments
    else
      @assignments = @course.assignments
    end
    render_role_based_view
  end

  def new
    token = @user.lms_credentials.first.token
    @courses = Course.fetch_courses(token)
    flash[:alert] = 'No courses found.' if @courses.empty?

    # Collect unique semester names from Canvas term data for the filter dropdown
    @semesters = @courses.filter_map { |c| c.dig('term', 'name') }.uniq.sort
    @selected_semester = params[:semester]

    teacher_enrollment_types = %w[teacher ta]
    # TODO: Add spec for when a course is created, but the user is not enrolled in it.
    # TODO: Why do some courses have empty enrollments?
    existing_canvas_ids = @user.courses.pluck(:canvas_id)
    @courses_teacher = filter_courses(@courses, teacher_enrollment_types, existing_canvas_ids)
    @courses_student = filter_courses(@courses, [ 'student' ], existing_canvas_ids)

    if @selected_semester.present?
      @courses_teacher = filter_by_semester(@courses_teacher, @selected_semester)
      @courses_student = filter_by_semester(@courses_student, @selected_semester)
    end
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
    return render json: { error: 'You do not have permission.' }, status: :forbidden unless @is_course_admin

    @course.sync_all_enrollments_from_canvas(@user.id)
    render json: { message: 'Users synced successfully.' }, status: :ok
  end

  def enrollments
    @side_nav = 'enrollments'
    return redirect_to courses_path, alert: 'You do not have access to this page.' unless @role == 'instructor'

    @enrollments = @course.user_to_courses.includes(:user)
    @is_course_admin = @course.course_admin?(@user)
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
  def set_course
    @course = Course.find_by(id: params[:id])
    redirect_to courses_path, alert: 'Course not found.' unless @course
  end

  def determine_user_role
    @role = @course&.user_role(@user)
    @is_course_admin = @course&.course_admin?(@user) || false
  end

  # Groups UserToCourse records by their course's semester, sorted most-recent-first.
  # Returns an array of [semester_name, [user_to_courses]] pairs.
  def group_by_semester(user_to_courses)
    grouped = user_to_courses.group_by { |utc| utc.course.semester }
    sorted_semesters = Course.sort_semesters(grouped.keys)
    sorted_semesters.map { |semester| [ semester, grouped[semester] ] }
  end

  # Filters Canvas API course hashes by their term name
  def filter_by_semester(courses, semester)
    courses.select { |c| c.dig('term', 'name') == semester }
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
