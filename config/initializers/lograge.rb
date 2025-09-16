if Rails.application.config.lograge.enabled

  # Log to ENVIRONMENT.rb
  if ENV["RAILS_LOG_TO_STDOUT"] == "true"
    log_dest = STDOUT
  else
    log_dest = Rails.root.join("log", "#{Rails.env}.log")
  end

  Rails.application.configure do
    config.logger = ActiveSupport::Logger.new(log_dest)
    config.lograge.formatter = Lograge::Formatters::Json.new
    config.colorize_logging = false
    config.lograge.ignore_actions = [ 'Rails::HealthController#show',
      'StatusController#health_check']

    config.lograge.custom_payload do |controller|
      {
        request_id: controller.request.uuid,
        user_id: controller.current_user.try(:id)
      }
    end
    config.lograge.custom_options = lambda do |event|
      exceptions = %w(controller action format id)
      options = {
        time: Time.now,
        params: event.payload[:params].except(*exceptions)
      }

      if event.payload[:exception]
        exception_class, exception_message = event.payload[:exception]
        options[:exception_class] = exception_class
        options[:exception_message] = exception_message
      end

      if event.payload[:exception_object]
        options[:exception_backtrace] = event.payload[:exception_object].backtrace.join("\n")
      end
      options
  end

    ActionDispatch::DebugExceptions.register_interceptor do |request, exception|
      case exception
      when ActionController::RoutingError
        data = {
          method: request.method,
          path: request.path,
          request_id: request.uuid,
          user_agent: request.user_agent,
          ip: request.ip,
          status: ActionDispatch::ExceptionWrapper.status_code_for_exception(exception.class.name),
          exception: [exception.class.name, exception.message]
        }

        formatted_message = Lograge.formatter.call(data)
        Rails.logger.send(Lograge.log_level, formatted_message)
      end
    end
  end
end
