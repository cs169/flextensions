class RequestsController < ApplicationController
  before_action :authenticate_user
  before_action :set_course_role_from_settings
  before_action :authenticate_course
  before_action :set_pending_request_count
  before_action :check_extensions_enabled_for_students
  before_action :ensure_request_is_pending, only: %i[update approve reject]
  before_action :set_request, only: %i[show edit cancel]
  before_action :check_instructor_permission, only: %i[approve reject]

  def index
    @side_nav = 'requests'
    @requests = @role == 'student' ? @course.requests.for_user(@user).order(created_at: :desc) : @course.requests.includes(:assignment).where(status: 'pending').order(created_at: :asc)
    render_role_based_view
  end

  def history
    return redirect_to course_path(@course.id), alert: 'You do not have access to this page.' unless @role == 'instructor'

    @side_nav = 'requests'
    @requests = @course.requests.includes(:assignment, :last_processed_by_user).where.not(status: 'pending').order(created_at: :asc)
    render_role_based_view(view: 'history')
  end

  def show
    @assignment = @request.assignment
    @number_of_days = @request.calculate_days_difference if @request.requested_due_date.present? && @assignment&.due_date.present?
    render_role_based_view
  end

  def new
    @side_nav = 'form'
    return redirect_to course_path(@course.id), alert: 'You do not have access to this page.' unless @role == 'student'

    course_to_lms = @course.course_to_lms(1)
    return redirect_to courses_path, alert: 'No LMS data found for this course.' unless course_to_lms

    @assignments = Assignment.enabled_for_course(course_to_lms.id).order(:name)
    @selected_assignment = Assignment.find_by(id: params[:assignment_id]) if params[:assignment_id]
    @request = @course.requests.new
  end

  def edit
    @selected_assignment = @request.assignment
    @assignments = [@selected_assignment]
  end

  def create
    merge_date_and_time!(params[:request])
    @request = @course.requests.new(request_params.merge(user: @user))

    if @request.save
      handle_auto_approval
    else
      handle_request_error
    end
  end

  def update
    @request = @course.requests.find_by(id: params[:id])
    return redirect_to course_path(@course), alert: 'Request not found.' unless @request

    merge_date_and_time!(params[:request])

    if @request.update(request_params)
      redirect_to course_request_path(@course, @request), notice: 'Request was successfully updated.'
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

  private

  def set_request
    @side_nav = 'requests'
    @request = @course.requests.includes(:assignment).find_by(id: params[:id])
    redirect_to course_path(@course), alert: 'Request not found.' unless @request
  end

  def check_instructor_permission
    redirect_to course_path(@course), alert: 'You do not have permission to perform this action.' unless @role == 'instructor'
  end

  def handle_request_error
    flash.now[:alert] = 'There was a problem submitting your request.'
    course_to_lms = @course.course_to_lms(1)
    @assignments = Assignment.where(course_to_lms_id: course_to_lms.id, enabled: true).order(:name)
    @selected_assignment = Assignment.find_by(id: params[:assignment_id]) if params[:assignment_id]
    render :new
  end

  def handle_auto_approval
    auto_approval_enabled = @course.course_settings&.enable_extensions &&
                            @course.course_settings.auto_approve_days.positive?

    if auto_approval_enabled && attempt_auto_approval
      redirect_to course_request_path(@course, @request),
                  notice: 'Your extension request has been automatically approved.'
    else
      redirect_to course_request_path(@course, @request),
                  notice: 'Your extension request has been submitted.'
    end
  end

  def attempt_auto_approval
    token = @user.lms_credentials.first&.token
    return false unless token.present? && @request.eligible_for_auto_approval?

    canvas_facade = CanvasFacade.new(token)
    @request.auto_approve(canvas_facade)
  end

  def set_course_role_from_settings
    @course = Course.find_by(id: params[:course_id])
    @role = @course.user_role(@user)
    @form_settings = @course&.form_setting
    return if @course

    flash[:alert] = 'Course not found.'
    redirect_to courses_path
  end

  def render_role_based_view(options = {})
    ctrl  = options[:controller] || controller_name
    act   = options[:view] || action_name
    instructor_view = "#{ctrl}/instructor_#{act}"
    student_view = "#{ctrl}/student_#{act}"

    case @role
    when 'instructor'
      render instructor_view
    when 'student'
      render student_view
    else
      redirect_to courses_path, alert: 'You do not have access to this course.'
    end
  end

  def merge_date_and_time!(request_params)
    return unless request_params[:requested_due_date].present? && request_params[:due_time].present?

    combined = Time.zone.parse("#{request_params[:requested_due_date]} #{request_params[:due_time]}")
    request_params[:requested_due_date] = combined
  end

  def request_params
    params.require(:request).permit(:assignment_id, :reason, :documentation, :custom_q1, :custom_q2, :requested_due_date)
  end

  def authenticate_user
    @user = User.find_by(canvas_uid: session[:user_id])
    return unless @user.nil?

    redirect_to root_path, alert: 'Please log in to access this page.'
  end

  def authenticate_course
    redirect_to courses_path, alert: 'Course not found.' unless @course
  end

  def ensure_request_is_pending
    @request = @course.requests.find_by(id: params[:id])
    if @request.nil?
      redirect_to course_path(@course), alert: 'Request not found.'
    elsif @request.status != 'pending'
      redirect_to course_path(@course), alert: 'This action can only be performed on pending requests.'
    end
  end

  def check_extensions_enabled_for_students
    return unless @role == 'student'

    course_settings = @course.course_settings
    return unless course_settings && !course_settings.enable_extensions

    redirect_to courses_path, alert: 'Extensions are not enabled for this course.'
  end
end
