module Api
  module V1
    class LmssController < BaseController
      before_action :validate_ids!, only: [:create]

      # POST /courses/:course_id/lmss
      def create
        course_id = params[:course_id]
        lms_id = params[:lms_id]

        # Ensure the course exists
        unless Course.exists?(course_id)
          render json: { error: 'Course not found' }, status: :not_found
          return
        end

        # Ensure the lms exists
        unless Lms.exists?(lms_id)
          render json: { error: 'Lms not found' }, status: :not_found
          return
        end

        # Check if the entry already exists
        existing_entry = CourseToLms.find_by(course_id: course_id, lms_id: lms_id)
        if existing_entry
          render json: { message: 'The association between the specified course and LMS already exists.' }, status: :ok
          return
        end

        # Create the course_to_lms entry
        course_to_lms = CourseToLms.new(
          course_id: course_id,
          lms_id: lms_id
        )

        if course_to_lms.save
          render json: course_to_lms, status: :created
        else
          render json: course_to_lms.errors, status: :unprocessable_entity
        end
      end

      def index
        render :json => 'not yet implemented'.to_json, status: 501
      end

      def destroy
        render :json => 'not yet implemented'.to_json, status: 501
      end

      ##
      # Validator definitions.
      # TODO: this should be exported to its own (validator) class.
      # TODO: this validation should also check the config file for the name of lms's.
      #
      def validate_ids!
        if params[:course_id].blank? || params[:lms_id].blank?
          render json: { error: 'course_id and lms_id are required' }, status: :bad_request
        end
      end
    end
  end
end
