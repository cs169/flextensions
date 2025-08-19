# == Schema Information
#
# Table name: course_to_lmss
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  course_id          :bigint
#  external_course_id :string
#  lms_id             :bigint
#
# Indexes
#
#  index_course_to_lmss_on_course_id  (course_id)
#  index_course_to_lmss_on_lms_id     (lms_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (lms_id => lmss.id)
#
class CourseToLms < ApplicationRecord
  # Associations
  belongs_to :course
  belongs_to :lms

  # Fetch assignments from Canvas API
  # TODO: Replace with call to Canvas Facade
  def fetch_canvas_assignments(token)
    url = "#{ENV.fetch('CANVAS_URL')}/api/v1/courses/#{external_course_id}/assignments"
    response = Faraday.get(url) do |req|
      req.headers['Authorization'] = "Bearer #{token}"
      req.headers['Content-Type'] = 'application/json'
      req.params['include[]'] = 'all_dates' # Include all dates in the response
    end

    if response.success?
      JSON.parse(response.body).map do |data|
        data['base_date'] = data['all_dates']&.find { |d| d['base'] }
        Lmss::Canvas::Assignment.new(data)
      end
    else
      Rails.logger.error "Failed to fetch assignments: #{response.status} - #{response.body}"
      []
    end
  end

  def fetch_gradescope_assignments
    return [] unless course.course_settings.enable_gradescope?

    client = Lmss::Gradescope.login(
      ENV.fetch('GRADESCOPE_EMAIL'),
      ENV.fetch('GRADESCOPE_PASSWORD')
    )

    course = Lmss::Gradescope::Course.new(external_course_id, client)
    assignments = course.assignments

    if assignments.any?
      assignments
    else
      Rails.logger.error 'Failed to fetch Gradescope assignments'
      []
    end
  end
end
