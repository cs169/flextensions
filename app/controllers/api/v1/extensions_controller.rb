module Api
    module V1
      class ExtensionsController < BaseController
        before_action :set_facade

        # Fetch all courses the current user has access to
        def index
          response = @canvas_facade.get_all_courses
          render json: response.body, status: response.status
      end

      # Create an assignment override (extension) for a student
      def create
        response = @canvas_facade.provision_exension(
          params[:course_id],
          params[:assignment_id],
          # Array of one student ID
          [params[:student_uid]], 
          "Extension due to #{params[:reason]}",
          params[:new_due_date],
        )
        render json: response.body, status: response.status
      end

      # Delete an existing assignment override (extension)
      def destroy
        response = @canvas_facade.delete_assignment_override(
          params[:course_id],
          params[:assignment_id],
          params[:override_id]
        )
        render json: response.body, status: response.status
      end

      private

      # Set up the CanvasFacade with the authorization token
      def set_facade
        @canvas_facade = CanvasFacade.new(request.headers['Authorization'])
      end
    end
  end
end
