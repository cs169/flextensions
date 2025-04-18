class RequestsController < ApplicationController
  before_action :authenticate_user
  before_action :set_course_role_from_settings
  before_action :authenticate_course

  def index
    @side_nav = 'requests'
    @requests = if @role == 'student'
                  @course.requests.where(user: @user).includes(:assignment)
                else
                  @course.requests.includes(:assignment)
                end
    render_role_based_view
  end

  def show
    @side_nav = 'requests'
    @request = @course.requests.includes(:assignment).find_by(id: params[:id])
    redirect_to course_path(@course), alert: 'Request not found.' and return if @request.nil?

    @assignment = @request.assignment

    # Calculate the number of days difference if both dates are present.
    @number_of_days = (@request.requested_due_date.to_date - @assignment.due_date.to_date).to_i if @request.requested_due_date.present? && @assignment&.due_date.present?

    render_role_based_view
  end

  def new
    @side_nav = 'form'

    return redirect_to course_path(@course.id), alert: 'You do not have access to this page.' unless @role == 'student'

    course_to_lms = @course.course_to_lms(1)
    return redirect_to courses_path, alert: 'No LMS data found for this course.' unless course_to_lms

    @assignments = if @role == 'student'
                     Assignment.where(course_to_lms_id: course_to_lms.id, enabled: true).order(:name)
                   else
                     Assignment.where(course_to_lms_id: course_to_lms.id).order(:name)
                   end
    @selected_assignment = Assignment.find_by(id: params[:assignment_id]) if params[:assignment_id]
    @request = @course.requests.new
  end

  def edit
    @request = @course.requests.find_by(id: params[:id])
    redirect_to course_path(@course), alert: 'Request not found.' and return if @request.nil?

    # Only one assignment: the one associated with this request.
    @selected_assignment = @request.assignment
    # Optionally, you can set @assignments as well:
    @assignments = [@selected_assignment]

    # The view will use @selected_assignment in the select options.
    # render_role_based_view
  end

  def create
    merge_date_and_time!(params[:request])
    @request = @course.requests.new(request_params)
    @request.user = @user

    if @request.save
      redirect_to course_request_path(@course, @request), notice: 'Your extension request has been submitted.'
    else
      flash.now[:alert] = 'There was a problem submitting your request.'
      course_to_lms = @course.course_to_lms(1)
      @assignments = Assignment.where(course_to_lms_id: course_to_lms.id, enabled: true).order(:name)
      @selected_assignment = Assignment.find_by(id: params[:assignment_id]) if params[:assignment_id]
      render :new
    end
  end

  def update
    @request = @course.requests.find_by(id: params[:id])
    redirect_to course_path(@course), alert: 'Request not found.' and return if @request.nil?

    merge_date_and_time!(params[:request])

    if @request.update(request_params)
      redirect_to course_request_path(@course, @request), notice: 'Request was successfully updated.'
    else
      flash.now[:alert] = 'There was a problem updating the request.'
      render :edit
    end
  end

  def destroy
    @request = @course.requests.find_by(id: params[:id])
    if @request
      @request.destroy
      redirect_to course_path(@course), notice: 'Request was successfully deleted.'
    else
      redirect_to course_path(@course), alert: 'Request not found.'
    end
  end

  def approve
    @request = @course.requests.find_by(id: params[:id])
    return redirect_to course_path(@course), alert: 'Request not found.' unless @request
    return redirect_to course_path(@course), alert: 'You do not have permission to perform this action.' unless @role == 'instructor'

    # Initialize the CanvasFacade
    canvas_facade = CanvasFacade.new(@user.lms_credentials.first.token)

    # Call Canvas API to create the assignment override
    response = canvas_facade.create_assignment_override(
      @course.canvas_id,
      @request.assignment.external_assignment_id,
      [@request.user.canvas_uid],
      "Extension for #{@request.user.name}",
      @request.requested_due_date.iso8601,
      nil, # Unlock date (optional)
      nil  # Lock date (optional)
    )

    Rails.logger.info "Canvas API response: #{response.status} - #{response.body}"

    if response.success?
      # Parse the response to get the override details
      assignment_override = JSON.parse(response.body)

      # Create a local Extension record
      extension = Extension.new(
        assignment_id: @request.assignment_id,
        student_email: @request.user.email,
        initial_due_date: @request.assignment.due_date,
        new_due_date: assignment_override['due_at'],
        external_extension_id: assignment_override['id'],
        last_processed_by_id: @user.id
      )

      if extension.save
        @request.update(status: 'approved', external_extension_id: assignment_override['id'])
        redirect_to course_requests_path(@course), notice: 'Request accepted and extension created successfully in Canvas.'
      else
        redirect_to course_requests_path(@course), alert: 'Extension created in Canvas, but failed to save locally.'
      end
    else
      redirect_to course_requests_path(@course), alert: "Failed to create extension in Canvas: #{response.body}"
    end
  end

  def reject
    @request = @course.requests.find_by(id: params[:id])
    return redirect_to course_path(@course), alert: 'Request not found.' unless @request
    return redirect_to course_path(@course), alert: 'You do not have permission to perform this action.' unless @role == 'instructor'

    if @request.update(status: 'denied')
      redirect_to course_requests_path(@course), notice: 'Request denied successfully.'
    else
      redirect_to course_requests_path(@course), alert: 'Failed to deny the request.'
    end
  end

  private

  def set_course_role_from_settings
    @course = Course.find_by(id: params[:course_id])
    @role = @course.user_role(@user)
    @form_settings = @course&.form_setting
    return if @course

    flash[:alert] = 'Course not found.'
    redirect_to courses_path
  end

  # Renders a view based on user role, defaulting to current controller and action.
  #
  # You can override the controller or action like so:
  #   render_role_based_view(controller: 'custom_controller', view: 'custom_action')
  #
  # By default, it uses:
  #   controller = controller_name (e.g. "requests")
  #   view       = action_name     (e.g. "new")
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

    date_str = request_params[:requested_due_date]
    time_str = request_params[:due_time]
    combined = Time.zone.parse("#{date_str} #{time_str}")
    request_params[:requested_due_date] = combined
  end

  def request_params
    params.require(:request).permit(
      :assignment_id,
      :reason,
      :documentation,
      :custom_q1,
      :custom_q2,
      :requested_due_date
    )
  end

  def authenticate_user
    @user = User.find_by(canvas_uid: session[:user_id])
    return unless @user.nil?

    redirect_to root_path, alert: 'Please log in to access this page.'
  end

  def authenticate_course
    redirect_to courses_path, alert: 'Course not found.' unless @course
  end
end
