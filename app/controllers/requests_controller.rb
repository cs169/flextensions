class RequestsController < ApplicationController
  before_action :authenticate_user
  before_action :set_course
  before_action :set_assignment_role
  before_action :authenticate_course

  def index
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

  def create
    @request = @course.requests.new(request_params)
    @request.user = @user

    if @request.save
      redirect_to course_request_path(@course, @request), notice: 'Your extension request has been submitted.'
    else
      flash.now[:alert] = 'There was a problem submitting your request.'
      render :new
    end
  end

  private

  def set_course
    @course = Course.find_by(id: params[:course_id])
    return if @course

    flash[:alert] = 'Course not found.'
    redirect_to courses_path
  end

  def set_assignment_role
    @assignment = Assignment.find_by(id: params[:assignment_id])
    @form_settings = @course&.form_setting
    @role = @course.user_role(@user)
    return if @assignment

    flash[:alert] = 'Assignment not found.'
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

  def request_params
    params.require(:request).permit(
      :assignment_id,
      :reason,
      :additional_doc,
      :custom_question_1,
      :custom_question_2,
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
