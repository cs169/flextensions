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
    @courses = fetch_courses(token)
    if @courses.empty?
      Rails.logger.info "No courses found."
      flash[:alert] = "No courses found."
    end
    @courses_teacher = @courses.select { |course| ["teacher", "ta"].include?(course["enrollment_type"]) }
    @courses_student = @courses.select { |course| course["enrollment_type"] == "student" }

  end

  private

  def fetch_courses(tokene)
    response = Faraday.get(ENV['CANVAS_URL'] + "/api/v1/courses") do |req|
      req.headers['Authorization'] = "Bearer #{token}"
      req.headers['Content-Type'] = "application/json"
      req.params['include[]'] = "enrollment_type"
    end

    if response.success?
      JSON.parse(response.body)
    else
      Rails.logger.error "Failed to fetch courses from Canvas: #{response.status} - #{response.body}"
      []
    end
  end

end
