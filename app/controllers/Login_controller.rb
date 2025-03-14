class LoginController < ApplicationController
  def login; end

  def canvas
    redirect_to canvas_authorize_url, allow_other_host: true
  end

  def bcourses
    create_session(:create_user)
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def canvas_authorize_url
    query_params = {
      client_id: ENV.fetch('CANVAS_CLIENT_ID', nil),
      response_type: 'code',
      redirect_uri: "#{ENV.fetch('CANVAS_REDIRECT_URI', nil)}/auth/canvas/callback",
      scope: 'url:GET|/api/v1/users/self profile email'
    }
    # canvas_callback

    ENV.fetch('CANVAS_URL', nil) + "/login/oauth2/auth?#{query_params.to_query}"

    # The following line is for testing purposes and skips redirections.
    # :canvas_callback
  end
end
