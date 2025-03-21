class CoursesController < ApplicationController
  def index; end

  def new
    user = User.find_by(canvas_uid: session[:user_id])
    if user.nil?
      Rails.logger.info 'User not found in session'
      redirect_to root_path, alert: 'Please log in to access this page.'
      return
    end
    token = user.canvas_token
    @courses = fetch_courses(token)
    if @courses.empty?
      Rails.logger.info 'No courses found.'
      flash[:alert] = 'No courses found.'
    end
    # Rails.logger.info "Courses: #{@courses}"
    teacher_roles = %w[teacher ta]
    @courses_teacher = @courses.select do |course|
      course['enrollments'].any? { |enrollment| teacher_roles.include?(enrollment['type']) }
    end

    @courses_student = @courses.select do |course|
      course['enrollments'].any? { |enrollment| enrollment['type'] == 'student' }
    end
  end

  private

  def fetch_courses(token)
    response = Faraday.get("#{ENV.fetch('CANVAS_URL', nil)}/api/v1/courses") do |req|
      req.headers['Authorization'] = "Bearer #{token}"
      req.headers['Content-Type'] = 'application/json'
      req.params['include[]'] = 'enrollment_type'
    end

    if response.success?
      JSON.parse(response.body)
    else
      Rails.logger.error "Failed to fetch courses from Canvas: #{response.status} - #{response.body}"
      []
    end
  end
end
