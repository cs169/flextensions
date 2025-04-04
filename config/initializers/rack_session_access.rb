if Rails.env.test?
  require 'rack_session_access'
  Rails.application.config.middleware.use RackSessionAccess::Middleware
end 