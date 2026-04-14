Rails.application.config.to_prepare do
  GoodJob::ApplicationController.before_action :require_admin
end
