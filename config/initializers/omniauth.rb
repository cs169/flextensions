# frozen_string_literal: true

require 'cgi'

OmniAuth::Strategies::Canvas.class_eval do
  def build_access_token
    verifier = request.params['code']
    client.auth_code.get_token(
      verifier,
      { redirect_uri: callback_url, scope: CanvasFacade::CANVAS_API_SCOPES },
      deep_symbolize(options.auth_token_params)
    )
  end
end


Rails.application.config.middleware.use OmniAuth::Builder do
  # URL-encode the scopes defined in CanvasFacade
  encoded_scopes = CGI.escape(CanvasFacade::CANVAS_API_SCOPES)

  provider :developer, fields: [:email] if Rails.env.development? || Rails.env.test?

  provider :canvas,
          ENV['CANVAS_CLIENT_ID'],
          ENV['CANVAS_APP_KEY'],
          client_options: {
            site: ENV['CANVAS_URL'],
            authorize_url: "/login/oauth2/auth?scope=#{encoded_scopes}"
          }
end

# OmniAuth.config.before_request_phase do |env|
#   Rails.logger.debug "AUTH URL: #{env['omniauth.strategy'].client.auth_code.authorize_url(authorize_params: env['omniauth.strategy'].authorize_params)}"
# end

OmniAuth.config.allowed_request_methods = [:get, :post]
OmniAuth.config.silence_get_warning = true

OmniAuth.config.on_failure = Proc.new do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end
