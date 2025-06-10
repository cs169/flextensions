require 'gradescope/assignment'

module Gradescope
  class Course
    def initialize(course_id, client)
      @course_id = course_id
      @client = client
    end

    def assignments
      response = @client.get("/courses/#{@course_id}/assignments")
      props = @client.extract_react_props(response.body, 'AssignmentsTable')

      return [] unless props

      assignments = props['table_data'] || []
      assignments.map { |data| Assignment.new(@course_id, data, @client) }
    end

    # def memberships
    #   response = @client.get("/courses/#{@course_id}/memberships")
    #   doc = Nokogiri::HTML(response.body)

    #   doc.css('button.rosterCell--editIcon').map do |button|
    #     Membership.new(
    #       {
    #         id: button.attr('data-id'),
    #         email: button.attr('data-email'),
    #         data: JSON.parse(button.attr('data-cm') || '{}'),
    #         role: button.attr('data-role'),
    #         logged_in: button.attr('data-logged-in') == 'true'
    #       }
    #     )
    #   end
    # rescue JSON::ParserError
    #   []
    # end
  end
end
