# frozen_string_literal: true

# TODO: Remove this after omniauth updates.
# This is heavy-handed, but allows :developer to work with a get request.
class OmniAuth::Form
  def header(title, header_info)
    @html << <<-HTML
    <!DOCTYPE html>
    <html>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <title>#{title}</title>
      #{css}
      #{header_info}
    </head>
    <body>
    <h1>#{title}</h1>
    <form method="get" #{"action='#{options[:url]}' " if options[:url]}noValidate='noValidate'>
    HTML
    self
  end
end

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