class BcoursesController < ApplicationController
  require 'lms_api'

  def index
    canvas_url = "https://bcourses.berkeley.edu"
    
    # Assuming LMS::Canvas.new expects a token directly. Adjust as needed for actual API wrapper usage.
    canvas_api_key = Rails.application.credentials.dig(:development, :canvas, :dev_api_key)   # this will be obtained from omniauth in later iterations
    api = LMS::Canvas.new(canvas_url, canvas_api_key)

    # byebug
    # Fetch courses list
    courses_url = "#{canvas_url}/api/v1/courses"
    @courses = api.api_get_request(courses_url)
  rescue LMS::Canvas::RefreshTokenRequired => e
    @error = "Token expired and needs refresh: #{e.message}"
    # In the future, we'll redirect to the Omni-auth page that requests a new token
  rescue SocketError, Errno::ECONNREFUSED => e
    @error = "Network connection error: #{e.message}"
  rescue Net::ReadTimeout, Net::OpenTimeout => e
    @error = "Network timeout: #{e.message}"
  rescue => e
    @error = "An unexpected error occurred: #{e.message}"
  end
end