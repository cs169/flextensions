class LoginController < ApplicationController
    def login; end

    def canvas
        redirect_to canvas_authorize_url
    end
    
    private def canvas_authorize_url
    query_params = {
      client_id: "26530~GXwfzFr2E4aerMfCKBDDkWuKuRuwk9RxCTVRc2Z3CeunPnxvXf8vFaYXe4GUP2BQ",
      response_type: 'code',
      redirect_uri: 'https://sp25-02-flextensions-4f5b4fbccd7f.herokuapp.com/offerings'
      #session_canvas_callback_url
    }
    
    "#{ENV['CANVAS_URL']}/login/oauth2/auth?#{query_params.to_query}"
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