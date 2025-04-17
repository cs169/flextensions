class ApplicationController < ActionController::Base
  before_action :authenticated!, unless: -> { excluded_controller_action? }

  def excluded_controller_action?
    # Actions and controllers that do NOT require authentication
    excluded_actions = {
      'home' => ['index'],
      'login' => ['canvas'],
      'session' => ['create'],
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
end
