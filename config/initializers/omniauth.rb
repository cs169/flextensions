Rails.application.config.middleware.use OmniAuth::Builder do
    provider :canvas, ENV['CANVAS_CLIENT_ID'], ENV['CANVAS_CLIENT_SECRET'], setup: lambda { |env|
      request = Rack::Request.new(env)
      env['omniauth.strategy'].options[:client_options].site = ENV["CANVAS_URL"]
    }
  end
  