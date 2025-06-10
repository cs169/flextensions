module Gradescope
  class Assignment
    attr_reader :id, :title, :due_date, :late_due_date

    def initialize(course_id, data, client)
      @course_id = course_id
      @client = client
      @id = data['id']
      @title = data['title']
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
  end
end
