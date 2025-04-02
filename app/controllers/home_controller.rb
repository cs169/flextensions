class HomeController < ApplicationController
  def index
    return if session[:user_id].blank?

    redirect_to courses_path
  end
end
