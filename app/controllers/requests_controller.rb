class RequestsController < ApplicationController
  before_action :authenticate_user, except: [:export]
  before_action :set_course_role_from_settings, except: [:export]
  before_action :authenticate_course
  before_action :set_pending_request_count, except: [:export]
  before_action :check_extensions_enabled_for_students, except: [:export]
  before_action :ensure_request_is_pending, only: %i[update approve reject]
  before_action :set_request, only: %i[show edit cancel]
  before_action :check_instructor_permission, only: %i[approve reject]

  def index
    @side_nav = 'requests'
    @requests = if params[:show_all] == 'true'
                  @role == 'student' ? @course.requests.for_user(@user) : @course.requests.includes(:assignment)
                else
                  @role == 'student' ? @course.requests.for_user(@user) : @course.requests.includes(:assignment).where(status: 'pending')
                end

    # Pass the search query to the view
    @search_query = params[:search]

    render_role_based_view
  end

  def show
    @assignment = @request.assignment
    @number_of_days = @request.calculate_days_difference if @request.requested_due_date.present? && @assignment&.due_date.present?
    render_role_based_view
  end

  def new
    @side_nav = 'form'
    course_to_lms = @course.course_to_lms(1)
    return redirect_to courses_path, alert: 'No LMS data found for this course.' unless course_to_lms

    if @role == 'instructor'
      prepare_instructor_new_request(course_to_lms)
      render :new_for_student and return
    elsif @role == 'student'
      redirected = prepare_student_new_request(course_to_lms)
      return if redirected

      render :new and return
    else
      redirect_to course_path(@course.id), alert: 'You do not have access to this page.'
    end
  end

  def new_for_student
    @side_nav = 'form'
    # Only instructors allowed
    return redirect_to course_requests_path(@course), alert: 'You do not have permission to access this page.' unless @role == 'instructor'

    course_to_lms = @course.course_to_lms(1)
    return redirect_to courses_path, alert: 'No LMS data found for this course.' unless course_to_lms

    all_assignments = Assignment.enabled_for_course(course_to_lms.id).order(:name)
    @assignments = all_assignments
    @students = User.joins(:user_to_courses).where(user_to_courses: { course_id: @course.id, role: 'student' }).order(:name)
    @request = @course.requests.new
  end

  def edit
    @selected_assignment = @request.assignment
    @assignments = [@selected_assignment]
  end

  def create
    Request.merge_date_and_time!(params[:request])
    @request = @course.requests.new(request_params.merge(user: @user))

    # Check if the assignment already has a pending request, but only if assignment_id exists
    if request_params[:assignment_id].present? &&
       Assignment.find_by(id: request_params[:assignment_id])&.has_pending_request_for_user?(@user, @course)
      redirect_to course_requests_path(@course), alert: 'You already have a pending request for this assignment.'
      return
    end

    if @request.save
      result = @request.process_created_request(@user)
      redirect_to result[:redirect_to], notice: result[:notice]
    else
      handle_request_error
    end
  end

  def create_for_student
    return redirect_to course_requests_path(@course), alert: 'You do not have permission to perform this action.' unless @role == 'instructor'

    student = User.find_by(id: params[:request][:user_id])
    return redirect_to new_course_request_path(@course), alert: 'Student not found.' unless student

    assignment_id = params[:request][:assignment_id]
    reject_other_student_requests(student, assignment_id) if assignment_id.present?

    Request.merge_date_and_time!(params[:request])
    @request = @course.requests.new(request_params.merge(user: student))
    if @request.save
      handle_successful_student_request(student)
    else
      prepare_instructor_new_request(@course.course_to_lms(1))
      flash.now[:alert] = 'There was a problem submitting the request.'
      render :new_for_student
    end
  end

  def update
    @request = @course.requests.find_by(id: params[:id])
    return redirect_to course_path(@course), alert: 'Request not found.' unless @request

    Request.merge_date_and_time!(params[:request])

    if @request.update(request_params)
      result = @request.process_update(@user)
      redirect_to result[:redirect_to], notice: result[:notice]
    else
      flash.now[:alert] = 'There was a problem updating the request.'
      render :edit
    end
  end

  def cancel
    if @request.reject(@user)
      redirect_to course_requests_path(@course), notice: 'Request canceled successfully.'
    else
      redirect_to course_requests_path(@course), alert: 'Failed to cancel the request.'
    end
  end

  def approve
    if @request.approve(CanvasFacade.new(@user.lms_credentials.first.token), @user)
      redirect_to course_requests_path(@course), notice: 'Request approved and extension created successfully in Canvas.'
    else
      redirect_to course_requests_path(@course), alert: 'Failed to approve the request.'
    end
  end

  def reject
    if @request.reject(@user)
      redirect_to course_requests_path(@course), notice: 'Request denied successfully.'
    else
      redirect_to course_requests_path(@course), alert: 'Failed to deny the request.'
    end
  end

  def export
    course = Course.find_by(id: params[:course_id])
    token = params[:readonly_api_token]

    unless course && ActiveSupport::SecurityUtils.secure_compare(course.readonly_api_token, token.to_s)
      return render plain: "Invalid or missing API token", status: :unauthorized
    end

    requests = course.requests.includes(:assignment, :user)
    if params[:status].present?
      requests = requests.where(status: params[:status])
    end

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Assignment", "Student Name", "Student ID", "Requested At", "Original Due Date", "Requested Due Date", "Status"]
      requests.find_each do |request|
        csv << [
          request.assignment&.name,
          request.user&.name,
          request.user&.student_id,
          request.created_at,
          request.assignment&.due_date,
          request.requested_due_date,
          request.status
        ]
      end
    end

    send_data csv_data, filename: "requests.csv", type: "text/csv"
  end

  private

  def set_request
    @side_nav = 'requests'
    @request = @course.requests.includes(:assignment).find_by(id: params[:id])
    redirect_to course_path(@course), alert: 'Request not found.' unless @request
  end

  def check_instructor_permission
    result = RequestService.check_instructor_permission(@role, course_path(@course))
    redirect_to result[:redirect_to], alert: result[:alert] if result != true
  end

  def handle_request_error
    flash.now[:alert] = 'There was a problem submitting your request.'
    course_to_lms = @course.course_to_lms(1)
    @assignments = Assignment.where(course_to_lms_id: course_to_lms.id, enabled: true).order(:name)
    @selected_assignment = Assignment.find_by(id: params[:assignment_id]) if params[:assignment_id]
    render :new
  end

  def set_course_role_from_settings
    result = RequestService.set_course_role_from_settings(params[:course_id], @user)

    if result[:redirect_to]
      redirect_to result[:redirect_to], alert: result[:alert]
      return
    end

    @course = result[:course]
    @role = result[:role]
    @form_settings = result[:form_settings]
  end

  def request_params
    params.require(:request).permit(:assignment_id, :reason, :documentation, :custom_q1, :custom_q2, :requested_due_date, :user_id)
  end

  def authenticate_user
    result = RequestService.authenticate_user(session[:user_id])

    if result[:redirect_to]
      redirect_to result[:redirect_to], alert: result[:alert]
      return
    end

    @user = result[:user]
  end

  def authenticate_course
    result = RequestService.authenticate_course(@course, courses_path)
    redirect_to result[:redirect_to], alert: result[:alert] if result != true
  end

  def ensure_request_is_pending
    @request = @course.requests.find_by(id: params[:id])
    result = RequestService.ensure_request_is_pending(@request, course_path(@course))
    redirect_to result[:redirect_to], alert: result[:alert] if result != true
  end

  def check_extensions_enabled_for_students
    result = RequestService.check_extensions_enabled_for_students(@role, @course, courses_path)
    redirect_to result[:redirect_to], alert: result[:alert] if result != true
  end

  def prepare_instructor_new_request(course_to_lms)
    @students = User.joins(:user_to_courses).where(user_to_courses: { course_id: @course.id, role: 'student' }).order(:name)
    @request = @course.requests.new
    @assignments = Assignment.enabled_for_course(course_to_lms.id).order(:name)
  end

  def prepare_student_new_request(course_to_lms)
    all_assignments = Assignment.enabled_for_course(course_to_lms.id).order(:name)
    @assignments = all_assignments.reject { |assignment| assignment.has_pending_request_for_user?(@user, @course) }
    @has_pending = all_assignments.size != @assignments.size
    @selected_assignment = Assignment.find_by(id: params[:assignment_id]) if params[:assignment_id]
    if @selected_assignment&.has_pending_request_for_user?(@user, @course)
      pending_request = @course.requests.where(user: @user, assignment: @selected_assignment, status: 'pending').first
      redirect_to course_request_path(@course, pending_request), alert: 'You already have a pending request for this assignment.'
      return true
    end
    @request = @course.requests.new
    false
  end

  def reject_other_student_requests(student, assignment_id)
    @course.requests.where(user_id: student.id, assignment_id: assignment_id)
           .where.not(status: 'denied')
           .find_each do |req|
      req.update(status: 'denied', last_processed_by_user_id: @user.id)
    end
  end

  def handle_successful_student_request(student)
    result = @request.process_created_request(@user)
    redirect_to result[:redirect_to], notice: "Request created for #{student.name}. #{result[:notice]}"
  end
end
