class ApplicationController < ActionController::Base
  before_action :authenticated!, unless: -> { excluded_controller_action? }

  def excluded_controller_action?
    # Actions and controllers that do NOT require authentication
    excluded_actions = {
      'home' => ['index'],
      'login' => ['canvas'],
      'session' => %w[create omniauth_callback],
      'rails/health' => ['show']
    }
    controller = params[:controller]
    action = params[:action]

    excluded_actions[controller]&.include?(action)
  end

  private

  # This method checks if the user has loggedin and has valid credentials.
  def authenticated!
    if session[:user_id].blank? || !Rails.env.test?
      @current_user = User.find_by(canvas_uid: session[:user_id])

      if @current_user.nil?
        return handle_authentication_failure('User not found in the database.')
      elsif @current_user.lms_credentials.empty?
        return handle_authentication_failure('User has no credentials.')
      elsif @current_user.lms_credentials.first.expire_time < Time.zone.now
        return handle_authentication_failure('User token has expired.')
      end
    end

    true
  rescue StandardError
    handle_authentication_failure('An unexpected error occurred.')
  end

  def handle_authentication_failure(message)
    # session[:user_id] = nil
    reset_session
    flash[:alert] = message
    redirect_to root_path
    false
  end

  def set_pending_request_count
    return unless defined?(@course) && @course.present? && defined?(@user) && @user.present?
    # only calculating pending requests count if the role is instructor so we don't show it to students
    return unless @course.user_role(@user) == 'instructor'

    @pending_requests_count = @course.requests.where(status: 'pending').count
  end

  # Renders a view based on user role, defaulting to current controller and action.
  #
  # You can override the controller or action like so:
  #   render_role_based_view(controller: 'custom_controller', view: 'custom_action')
  #
  # By default, it uses:
  #   controller = controller_name
  #   view       = action_name
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
      redirect_to courses_path, alert: 'You do not have access to this view.'
    end
  end

  protected

  def set_course
    @course = Course.find_by(id: params[:course_id])
    if @course.nil?
      flash[:alert] = 'Course not found.'
      redirect_to courses_path
      return
    end
    @role = @course.user_role(@user) if @user
  end

  def ensure_instructor_role
    return if @role == 'instructor'

    flash[:alert] = 'You do not have access to this page.'
    redirect_to courses_path
  end

  def authenticate_user
    @user = User.find_by(canvas_uid: session[:user_id])
    return unless @user.nil?

    redirect_to root_path, alert: 'User not found in the database.'
  end
end
