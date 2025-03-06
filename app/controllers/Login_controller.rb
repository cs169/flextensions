class LoginController < ApplicationController
    def login; end

    def canvas
        redirect_to canvas_authorize_url, allow_other_host: true
    end
    
    private def canvas_authorize_url
    query_params = {
      client_id: ENV['CANVAS_CLIENT_ID'],
      response_type: 'code',
      redirect_uri: ENV["CANVAS_REDIRECT_URI"] + "/auth/canvas/callback",
    }
    #canvas_callback

    "https://ucberkeleysandbox.instructure.com/login/oauth2/auth?#{query_params.to_query}"

    #The following line is for testing purposes and skips redirections.
    #:canvas_callback
  end

    def bcourses
        create_session(:create_user)
    end
    
    def logout
        session[:user_id] = nil
        redirect_to root_path
    end
  end