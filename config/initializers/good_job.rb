Rails.application.config.to_prepare do
  GoodJob::ApplicationController.class_eval do
    def current_user
      @current_user ||= User.find_by(canvas_uid: session[:user_id])
    end

    before_action :require_admin

    def require_admin
      if current_user.nil?
        redirect_to '/', alert: 'You must be logged in.'
      elsif !current_user.admin?
        redirect_to '/', alert: 'You are not authorized to view this page.'
      end
    end
  end
end
