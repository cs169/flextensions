class ApplicationController < ActionController::Base
  before_action :authenticated!, unless: -> { excluded_controller_action? }

  def excluded_controller_action?
    # Actions and controllers that do NOT require authentication
    excluded_actions = {
      'home' => ['index'],
      'login' => ['canvas'],
      'session' => ['create'],
      'rails/health' => ['show']
      # 'courses' => ['index', 'show', 'new']
    }
    controller = params[:controller]
    action = params[:action]

    excluded_actions[controller]&.include?(action)
  end

  private

  def authenticated!
    return unless session[:user_id].nil?

    redirect_to root_path, alert: 'Please log in to access this page.'
  end

  def authenticated!
    return unless session[:user_id].nil?

    redirect_to root_path, alert: 'Please log in to access this page.'
  end
end
