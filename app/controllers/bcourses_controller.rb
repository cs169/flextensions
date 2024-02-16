class BcoursesController < ApplicationController
  require 'lms_api'

  def index
    auth = Authentication.first
    canvas_url = "https://bcourses.berkeley.edu"
    
    # Assuming LMS::Canvas.new expects a token directly. Adjust as needed for actual API wrapper usage.
    api = LMS::Canvas.new(canvas_url, auth.access_token)

    # byebug
    # Fetch courses list
    courses_url = "#{canvas_url}/api/v1/courses"
    @courses = api.api_get_request(courses_url)
  rescue StandardError => e
    @error = "Failed to fetch courses: #{e.message}"
  end
end