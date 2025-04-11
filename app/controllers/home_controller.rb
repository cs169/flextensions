class HomeController < ApplicationController
  def index
    return unless authenticated!

    redirect_to courses_path
  end
end
