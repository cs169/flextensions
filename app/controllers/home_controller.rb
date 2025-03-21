class HomeController < ApplicationController
  def index
    return unless session[:user_id].present?

    redirect_to courses_path
  end
end
