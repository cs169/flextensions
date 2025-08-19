module API
  module V1
    class LmssController < BaseController
      include CanvasValidationHelper
      before_action :validate_ids!, only: [:create]

      def index
        render json: { message: 'not yet implemented' }, status: :not_implemented
      end

      # POST /courses/:course_id/lmss
      def create
        course_id = params[:course_id]
        lms_id = params[:lms_id]
        external_course_id = params[:external_course_id]

        # Ensure that the course and LMS exist
        unless Course.exists?(course_id)
          render json: { error: 'Course not found' }, status: :not_found
          return
        end
        unless Lms.exists?(lms_id)
          render json: { error: 'Lms not found' }, status: :not_found
          return
        end
        # Ensure that the association does not already exist
        existing_entry = CourseToLms.find_by(course_id: course_id, lms_id: lms_id,
                                             external_course_id: external_course_id)
        if existing_entry
          render json: { message: 'The association between the specified course and LMS already exists.' },
                 status: :ok
          return
        end
        # Create the association
        course_to_lms = CourseToLms.new(
          course_id: course_id,
          lms_id: lms_id,
          external_course_id: external_course_id
        )

        if course_to_lms.save
          render json: course_to_lms, status: :created
        else
          render json: course_to_lms.errors, status: :unprocessable_entity
        end
      end

      def destroy
        render json: { message: 'not yet implemented' }, status: :not_implemented
      end

      private

      def validate_ids!
        params.require(%i[course_id lms_id external_course_id])
      rescue ActionController::ParameterMissing => e
        render json: { error: e.message }, status: :bad_request
        nil
      else
        unless is_valid_course_id(params[:course_id].to_i) && is_valid_lms_id(params[:lms_id].to_i)
          render json: { error: 'Invalid course_id or lms_id' }, status: :bad_request
          nil
        end
      end
    end
  end
end
