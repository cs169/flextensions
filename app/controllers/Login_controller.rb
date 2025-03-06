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


    def create_session(create_if_not_exists)
        user_info = request.env['omniauth.auth']
        user = find_or_create_user(user_info, create_if_not_exists)
        session[:current_user_id] = user.uid
        destination_url = session[:destination_after_login] || root_url
        session[:destination_after_login] = nil
        redirect_to destination_url
    end

    def find_or_create_user(user_info, create_if_not_exists)
        user = User.find_by(
            uid:      user_info['uid']
        )
        return user unless user.nil?
        send(create_if_not_exists, user_info)
    end

    def create_canvas_user(user_info)
        User.create(
            uid:        user_info['uid'],
            email:      user_info['email']
        )
    end

  end