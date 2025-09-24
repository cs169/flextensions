require 'lmss/base_assignment'

module Lmss
  module Gradescope
    class Assignment < Lmss::BaseAssignment
      attr_reader :id, :name, :due_date, :late_due_date

      def initialize(data)
        # @course_id = course_id
        # @client = client
        @id = parse_id(data['id'])
        @name = data['title']
        @due_date = data.dig('submission_window', 'due_date')
        @late_due_date = data.dig('submission_window', 'hard_due_date')
      end

      # def extensions
      #   response = @client.get("/courses/#{@course_id}/assignments/#{@id}/extensions")
      #   props = @client.extract_react_props(response.body, 'ExtensionsTable')

      #   return [] unless props

      #   extensions = props['extensions'] || []
      #   extensions.map { |data| Extension.new(data) }
      # end

      # def create_extension(user_id, settings)
      #   extension_data = {
      #     override: {
      #       user_id: user_id,
      #       settings: settings
      #     }
      #   }

      #   @client.post("/courses/#{@course_id}/assignments/#{@id}/extensions", extension_data)
      # end

      private

      def parse_id(raw_id)
        raw_id[/\d+/].to_i
      end
    end
  end
end
