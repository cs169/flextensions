# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, fields: [:email] if Rails.env.development? || Rails.env.test?

  provider :canvas, ENV["CANVAS_CLIENT_ID"], ENV["CANVAS_APP_KEY"],
  {
    client_options: {
      site: ENV["CANVAS_URL"] ,
      authorize_url: '/login/oauth2/auth',
      token_url: '/login/oauth2/token'
    }
  }
  # provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], skip_jwt: true

  # provider :microsoft_graph, ENV["MICROSOFT_CLIENT_ID"], ENV["MICROSOFT_CLIENT_SECRET"],
  #          { scope: "openid profile email User.read" }

  # provider :discourse, sso_url: ENV["SNAP_CLIENT_URL"], sso_secret: ENV["SNAP_CLIENT_SECRET"]

  # provider :clever, ENV["CLEVER_CLIENT_ID"], ENV["CLEVER_CLIENT_SECRET"]

  # provider :yahoo_OAuth2, ENV["YAHOO_CLIENT_ID"], ENV["YAHOO_CLIENT_SECRET"], name: "yahoo"
end

OmniAuth.config.on_failure = Proc.new do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end