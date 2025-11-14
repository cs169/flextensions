module API
  module V1
    class RequestsController < BaseController
      before_action :set_facade

      def index
        render json: { message: 'not yet implemented' }, status: :not_implemented
      end

      def create
        find_extension_params
        # Get External Assignment object to find initial due date
        assignment_response = @canvas_facade.get_assignment(
          @course_to_lms.external_course_id.to_i,
          @assignment.external_assignment_id.to_i
        )
        if assignment_response.status != 200
          render json: assignment_response.to_json, status: :internal_server_error
          return
        end
        assignment_json = JSON.parse(assignment_response.body)

        # Provision Extension
        response = @canvas_facade.provision_extension(
          @course_to_lms.external_course_id.to_i,
          params[:student_uid].to_i,
          @assignment.external_assignment_id.to_i,
          params[:new_due_date]
        )
        unless response.success?
          render json: response.body, status: response.status
          return
        end
        assignment_override = JSON.parse(response.body)

        @extension = Extension.new(
          assignment_id: @assignment.id,
          student_email: nil,
          initial_due_date: assignment_json['due_at'],
          new_due_date: assignment_override['due_at'],
          external_extension_id: assignment_override['id'],
          last_processed_by_id: nil
        )
        unless @extension.save
          render json: { error: 'Extension requested, but local save failed' }.to_json, status: :internal_server_error
          return
        end
        render json: @extension.to_json, status: :ok
      end

      def destroy
        render json: { message: 'not yet implemented' }, status: :not_implemented
      end

      private

      def set_facade
        Rails.logger.info "Using CANVAS_URL: #{ENV.fetch('CANVAS_URL', nil)}"
        # not sure if auth key will be in the request headers or in cookie
        @canvas_facade = CanvasFacade.new(request.headers['Authorization'])
      end

      def find_extension_params
        @lms = Lms.find(params[:lms_id])
        @course = Course.find(params[:course_id])
        @assignment = Assignment.find(params[:assignment_id])
        @course_to_lms = CourseToLms.find(@assignment.course_to_lms_id)
      end
    end
  end
end
