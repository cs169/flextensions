# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, fields: [:email] if Rails.env.development? || Rails.env.test?

  provider :canvas, ENV["CANVAS_CLIENT_ID"], ENV["CANVAS_APP_KEY"],
  {
    client_options: {
      site: ENV["CANVAS_URL"] ,
      authorize_url: '/login/oauth2/auth',
      token_url: '/login/oauth2/token',
      scope: CanvasFacade::CANVAS_API_SCOPES,
    }
  }
end

OmniAuth.config.on_failure = Proc.new do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end
