class CourseToLms < ApplicationRecord
  # Associations
  belongs_to :course
  belongs_to :lms

  # Fetch assignments from Canvas API
  # TODO: Replace with call to Canvas Facade
  def fetch_assignments(token)
    url = "#{ENV.fetch('CANVAS_URL')}/api/v1/courses/#{external_course_id}/assignments"
    response = Faraday.get(url) do |req|
      req.headers['Authorization'] = "Bearer #{token}"
      req.headers['Content-Type'] = 'application/json'
      req.params['include[]'] = 'all_dates' # Include all dates in the response
    end

    if response.success?
      assignments = JSON.parse(response.body)

      # Process assignments to extract base dates
      assignments.each do |assignment|
        if assignment['all_dates']
          base_date = assignment['all_dates'].find { |date| date['base'] == true }
          assignment['base_date'] = base_date
        end
      end

      assignments
    else
      Rails.logger.error "Failed to fetch assignments: #{response.status} - #{response.body}"
      []
    end
  end
end
