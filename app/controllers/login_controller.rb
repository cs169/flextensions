class LoginController < ApplicationController
  # TODO: Remove login controller and move logout to session controller.
  # TODO: Does this route need to exist?
  # def canvas
  #   redirect_to canvas_authorize_url, allow_other_host: true
  # end

  # def bcourses
  #   create_session(:create_user)
  # end

  def logout
    reset_session
    redirect_to root_path
  end

  # private

  # # TODO: Replace this with the CanvasFacade
  # def canvas_authorize_url
  #   query_params = {
  #     client_id: ENV.fetch('CANVAS_CLIENT_ID', nil),
  #     response_type: 'code',
  #     state: SecureRandom.hex(16),
  #     redirect_uri: "#{ENV.fetch('CANVAS_REDIRECT_URI', nil)}/auth/canvas/callback",
  #     scope: CanvasFacade::CANVAS_API_SCOPES
  #   }

  #   ENV.fetch('CANVAS_URL', nil) + "/login/oauth2/auth?#{query_params.to_query}"
  # end
end
