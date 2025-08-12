# frozen_string_literal: true

# OmniAuth::Strategies::Canvas.class_eval do
#   def authorize_params
#     super.tap do |params|
#       if params['authorize_params']
#         scope_value = params['authorize_params'].delete('scope')
#         params['scope'] = scope_value if scope_value
#       end
#     end
#   end

#   def build_access_token
#     verifier = request.params['code']
#     begin
#       client.auth_code.get_token(
#         verifier,
#         {
#           redirect_uri: callback_url,
#           scope: options[:authorize_params][:scope] || options[:scope]
#         },
#         deep_symbolize(options.auth_token_params)
#       )
#     rescue OAuth2::Error => e
#       Rails.logger.error "OAuth2 token exchange failed: #{e.message} - #{e.response.body}"
#       raise
#     end
#   end
# end



Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, fields: [:email] if Rails.env.development? || Rails.env.test?

  # provider :canvas,
  #        ENV["CANVAS_CLIENT_ID"],
  #        ENV["CANVAS_APP_KEY"],
  #        client_options: {
  #          site: ENV["CANVAS_URL"],
  #          authorize_url: "/login/oauth2/auth?scope=#{CGI.escape(CanvasFacade::CANVAS_API_SCOPES)}"
  #        }

  provider :canvas, ENV["CANVAS_CLIENT_ID"], ENV["CANVAS_APP_KEY"],
            {
              client_options: {
                site: ENV["CANVAS_URL"] ,
                authorize_url: "/login/oauth2/auth?scope=#{CGI.escape(CanvasFacade::CANVAS_API_SCOPES)}"
                # authorize_url: '/login/oauth2/auth',
                # token_url: '/login/oauth2/token',
                # scope: 'url:GET|/api/v1/users/:id',
                # scope: CanvasFacade::CANVAS_API_SCOPES,
              },
              # authorize_params: { scope: CanvasFacade::CANVAS_API_SCOPES },
              # scope: CanvasFacade::CANVAS_API_SCOPES
            }
end

OmniAuth.config.before_request_phase do |env|
  Rails.logger.debug "AUTH URL: #{env['omniauth.strategy'].client.auth_code.authorize_url(authorize_params: env['omniauth.strategy'].authorize_params)}"
end

OmniAuth.config.allowed_request_methods = [:get, :post]
OmniAuth.config.silence_get_warning = true
OmniAuth.config.on_failure = Proc.new do |env|
  error = env['omniauth.error']
  error_type = env['omniauth.error.type']
  strategy = env['omniauth.error.strategy']
  Rails.logger.error "Omniauth failure: #{error_type} - #{error.inspect} on strategy #{strategy&.name}"
  Rails.logger.error "Full env keys: #{env.keys.inspect}"

  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end
