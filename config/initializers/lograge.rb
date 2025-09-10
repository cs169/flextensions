if Rails.application.config.lograge.enabled
  Rails.application.configure do
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
