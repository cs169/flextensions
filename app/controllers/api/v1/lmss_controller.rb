module Api
  module V1
    class LmssController < BaseController
      before_action :validate_ids!, only: [:create]

      def index
        render json: 'not yet implemented', status: 501
      end

      def destroy
        render json: 'not yet implemented', status: 501
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
        existing_entry = CourseToLms.find_by(course_id: course_id, lms_id: lms_id, external_course_id: external_course_id)
        if existing_entry
          render json: { message: 'The association between the specified course and LMS already exists.' }, status: :ok
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

      private

      # Improved validate_ids! to include integer validation
      def validate_ids!
        required_params = [:course_id, :lms_id, :external_course_id]
        missing_params = required_params.select { |param| params[param].blank? }

        if missing_params.any?
          render json: { error: 'course_id and lms_id are required' }, status: :bad_request
          return
        end

        unless params[:course_id].to_s.match?(/\A\d+\z/) && params[:lms_id].to_s.match?(/\A\d+\z/)
          render json: { error: 'course_id and lms_id must be integers' }, status: :bad_request
          return
        end
      end
    end
  end
end