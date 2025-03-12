class OfferingsController < ApplicationController
  def index
  end

  def new
    user = nil
    user = User.find_by(id: session[:user_id])
    if user.nil?
      Rails.logger.info "User not found in session"
      redirect_to root_path, alert: "Please log in to access this page."
      return
    end
    token = user.canvas_token
    Rails.logger.info "User token: #{token}"
    response = Faraday.get(ENV['CANVAS_URL'] + "/api/v1/courses") do |req|
      req.headers['Authorization'] = "Bearer #{token}"
      req.headers['Content-Type'] = 'application/json'
    end

    if response.success?
      @courses = JSON.parse(response.body)
    else
      @courses = []
      Rails.logger.error "Failed to fetch courses from Canvas: #{response.status}"
      flash[:alert] = "Failed to fetch courses from Canvas: #{response.status}"
    end
  end
end
