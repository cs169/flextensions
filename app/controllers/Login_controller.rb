class LoginController < ApplicationController
    def canvas
      #TODO: redirect_to canvas_authorize_url
    end
  
    private def canvas_authorize_url
        # TODO
    #   query_params = {
    #     client_id: CANVAS_CLIENT_ID,
    #     response_type: 'code',
    #     redirect_uri: session_canvas_callback_url
    #   }
    #   "#{CANVAS_URL}/login/oauth2/auth?#{query_params.to_query}"
    end
  end