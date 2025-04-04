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
    unless session[:user_id].nil?
      # User has logged in
      return true if Rails.env.test?

      @current_user = User.find_by(canvas_uid: session[:user_id])
      if @current_user.nil?
        # User is not found in the database
        puts('User not found in the database.')
        redirect_to root_path#, flash: 'User not found.'
        return false
      elsif @current_user.lms_credentials.empty?
        puts('User has no credentials.')
        redirect_to root_path#, flash: 'Invalid user credentials.'
        return false
      elsif @current_user.lms_credentials.first.expire_time < Time.zone.now
        puts(@current_user.lms_credentials.first.expire_time)
        puts(Time.zone.now)
        puts('User token has expired.')
        # User's token has expired
        redirect_to root_path#, flash: 'Your session has expired. Please log in again.'
        return false
      elsif @current_user.lms_credentials.first.expire_time > Time.zone.now
        puts('User token is still valid.')
        # User's token is still valid
        return true
      else
        # Unhandled cases
        puts('An unexpected error occurred.')
        redirect_to root_path#, flash: 'An unexpected error occurred.'
        return false
      end
    end
    redirect_to root_path, alert: 'Please log in to access this page.'
  end
end
