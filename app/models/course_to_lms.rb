class CourseToLms < ApplicationRecord
  # Associations
  belongs_to :course
  belongs_to :lms

  # Fetch assignments from Canvas API
  def fetch_assignments(token)
    url = "#{ENV.fetch('CANVAS_URL')}/api/v1/courses/#{external_course_id}/assignments"
    response = Faraday.get(url) do |req|
      req.headers['Authorization'] = "Bearer #{token}"
      req.headers['Content-Type'] = 'application/json'
    end

    if response.success?
      JSON.parse(response.body)
    else
      Rails.logger.error "Failed to fetch assignments: #{response.status} - #{response.body}"
      []
    end
  end
end
