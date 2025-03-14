class OfferingsController < ApplicationController
  def index; end

  def new
    user = User.find_by(id: session[:user_id])
    if user.nil?
      Rails.logger.info 'User not found in session'
      redirect_to root_path, alert: 'Please log in to access this page.'
      return
    end
    token = user.canvas_token
    @courses = fetch_combined_courses(token, %w[TeacherEnrollment TaEnrollment])
    if @courses.empty?
      Rails.logger.info 'No courses found for teacher.'
      flash[:alert] = 'No courses found for teacher.'
    end

    @courses_student = fetch_courses(token, 'StudentEnrollment')
    return unless @courses_student.empty?

    Rails.logger.info 'No courses found for student.'
    flash.now[:alert] = 'No courses found for student.'
  end

  private

  def fetch_courses(token, enrollment_type)
    response = Faraday.get("#{ENV.fetch('CANVAS_URL', nil)}/api/v1/courses") do |req|
      req.headers['Authorization'] = "Bearer #{token}"
      req.headers['Content-Type'] = 'application/json'
      req.headers['enrollment_role'] = enrollment_type
    end

    if response.success?
      JSON.parse(response.body)
    else
      Rails.logger.error "Failed to fetch #{enrollment_type} courses from Canvas: #{response.status} - #{response.body}"
      []
    end
  end

  def fetch_combined_courses(token, enrollment_types)
    combined_courses = []
    enrollment_types.each do |enrollment_type|
      combined_courses += fetch_courses(token, enrollment_type)
    end
    combined_courses
  end
end
