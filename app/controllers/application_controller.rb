class ApplicationController < ActionController::Base
    before_action :authenticated

    private def authenticated
        @authenticated = !session[:user_id].nil?
    end
end
