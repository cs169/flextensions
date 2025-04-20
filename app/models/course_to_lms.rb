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
      req.params['include[]'] = 'all_dates' # Include all dates in the response
    end

    if response.success?
      assignments = JSON.parse(response.body)

      # Process assignments to extract base dates
      assignments.each do |assignment|
        if assignment['all_dates']
          base_date = assignment['all_dates'].find { |date| date['base'] == true }
          if base_date
            assignment['base_date'] = base_date
            Rails.logger.info "Base date found for assignment #{assignment['id']}: #{base_date}"
          else
            Rails.logger.warn "No base date found for assignment #{assignment['id']}"
          end
        else
          Rails.logger.warn "No 'all_dates' field for assignment #{assignment['id']}"
        end
      end

      assignments
    else
      Rails.logger.error "Failed to fetch assignments: #{response.status} - #{response.body}"
      []
    end
  end
end
