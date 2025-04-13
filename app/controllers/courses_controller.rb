class CoursesController < ApplicationController
  before_action :authenticate_user
  before_action :set_course, only: %i[show edit form requests sync_assignments sync_enrollments enrollments]
  before_action :determine_user_role

  def index
    Lms.find_or_create_by(id: 1, lms_name: 'Canvas', use_auth_token: true)
    @teacher_courses = UserToCourse.includes(:course).where(user: @user, role: %w[teacher ta])
    @student_courses = UserToCourse.includes(:course).where(user: @user, role: 'student')
  end

  def show
    @side_nav = 'show'
    return redirect_to courses_path, alert: 'Course not found.' unless @course

    course_to_lms = @course.course_to_lms(1)
    return redirect_to courses_path, alert: 'No LMS data found for this course.' unless course_to_lms

    @assignments = Assignment.where(course_to_lms_id: course_to_lms.id)
    render_role_based_view
  end

  def new
    token = @user.canvas_token
    @courses = Course.fetch_courses(token)
    flash[:alert] = 'No courses found.' if @courses.empty?

    teacher_roles = %w[teacher ta]
    existing_canvas_ids = Course.pluck(:canvas_id)
    @courses_teacher = filter_courses(@courses, teacher_roles, existing_canvas_ids)
    @courses_student = @courses.select { |c| c['enrollments'].any? { |e| e['type'] == 'student' } }
  end

  def edit
    @side_nav = 'edit'
    redirect_to course_path(@course.id), alert: 'You do not have access to this page.' unless @role == 'instructor'
  end

  def requests
    @side_nav = 'requests'
    render_role_based_view('instructor_request_view', 'student_request_view')
  end

  def form
    @side_nav = 'form'
    return redirect_to course_path(@course.id), alert: 'You do not have access to this page.' unless @role == 'student'

    course_to_lms = @course.course_to_lms(1)
    return redirect_to courses_path, alert: 'No LMS data found for this course.' unless course_to_lms

    @assignments = Assignment.where(course_to_lms_id: course_to_lms.id)
    @selected_assignment = Assignment.find_by(id: params[:assignment_id]) if params[:assignment_id]
  end

  def new_request
    redirect_to course_extension_form_path(params[:course_id], assignment_id: params[:assignment_id])
  end

  def create
    token = @user.canvas_token
    courses_teacher = filter_courses(Course.fetch_courses(token), %w[teacher ta])
    selected_courses = courses_teacher.select { |c| params[:courses]&.include?(c['id'].to_s) }
    selected_courses.each { |course_data| Course.create_or_update_from_canvas(course_data, token, @user) }
    redirect_to courses_path, notice: 'Selected courses and their assignments have been imported successfully.'
  end

  def sync_assignments
    return render json: { error: 'Course not found.' }, status: :not_found unless @course

    Course.create_or_update_from_canvas(course_data_for_sync, @user.canvas_token, @user)
    render json: { message: 'Assignments synced successfully.' }, status: :ok
  end

  def sync_enrollments
    return render json: { error: 'Course not found.' }, status: :not_found unless @course

    @course.sync_enrollments_from_canvas(@user.canvas_token)
    render json: { message: 'Users synced successfully.' }, status: :ok
  end

  def enrollments
    @side_nav = 'enrollments'
    return redirect_to courses_path, alert: 'You do not have access to this page.' unless @role == 'instructor'

    @enrollments = @course.user_to_courses.includes(:user)
  end

  def delete_all
    user_courses = Course.joins(:user_to_courses).where(user_to_courses: { user_id: @user.id })
    Assignment.where(course_to_lms_id: CourseToLms.where(course_id: user_courses).select(:id)).destroy_all
    CourseToLms.where(course_id: user_courses).destroy_all
    UserToCourse.where(course_id: user_courses).destroy_all
    Course.where.missing(:user_to_courses).destroy_all
    redirect_to courses_path, notice: 'All your courses and associations have been deleted successfully.'
  end

  private

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

  def render_role_based_view(instructor_view = 'courses/instructor_view', student_view = 'courses/student_view')
    case @role
    when 'instructor' then render instructor_view
    when 'student' then render student_view
    else redirect_to courses_path, alert: 'You do not have access to this course.'
    end
  end

  def filter_courses(courses, roles, exclude_ids = [])
    courses.select do |course|
      course['enrollments'].any? { |e| roles.include?(e['type']) } && exclude_ids.exclude?(course['id'].to_s)
    end
  end

  def course_data_for_sync
    { 'id' => @course.canvas_id, 'name' => @course.course_name, 'course_code' => @course.course_code }
  end
end
