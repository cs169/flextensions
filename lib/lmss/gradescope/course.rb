module Lmss
  module Gradescope
    class Course
      def initialize(course_id, client)
        @course_id = course_id
        @client = client
      end

      def assignments
        html = @client.get("/courses/#{@course_id}/assignments")
        # if !response
        #   Rails.logger.error "Failed to fetch assignments: No response"
        #   return []
        # elsif response.status == 401 || response.status == 403
        #   raise Lmss::Gradescope::AuthenticationError, "Unauthorized access: #{response&.body}"
        # elsif !response&.success?
        #   Rails.logger.error "Failed to fetch assignments: #{response&.body}"
        #   return []
        # end

        props = @client.extract_react_props(html, 'AssignmentsTable')

        return [] unless props

        assignments = props['table_data'] || []
        assignments.map { |data| Lmss::Gradescope::Assignment.new(@course_id, data, @client) }
        binding.irb
        assignments
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
end
