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
  rescue StandardError => e
    @error = "Failed to fetch courses: #{e.message}"
  end
end