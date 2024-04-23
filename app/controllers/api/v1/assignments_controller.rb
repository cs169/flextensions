module Api
  module V1
    class AssignmentsController < ApplicationController
      before_action :validate_ids!, only: [:create]

      def index
        render json: 'not yet implemented', status: 501
      end

      # POST /courses/:course_id/lms/:lms_id/assignments
      def create
        # Check if the course_to_lms association exists
        course_to_lms = fetch_course_to_lms(params[:course_id], params[:lms_id])
        unless course_to_lms
          render json: { error: 'No such Course_LMS association' }, status: :not_found
          return
        end

        # Check if the assignment already exists
        if assignment_exists?(course_to_lms, params[:name], params[:external_assignment_id])
          render json: { message: 'Record already exists' }, status: :ok
          return
        end

        # Create and render the assignment
        assignment = Assignment.new(course_to_lms_id: course_to_lms.id, name: params[:name], external_assignment_id: params[:external_assignment_id])
        if assignment.save
          render json: assignment, status: :created
        else
          render json: assignment.errors, status: :unprocessable_entity
        end
      end

      def destroy
        render json: 'not yet implemented', status: 501
      end

      private

      def fetch_course_to_lms(course_id, lms_id)
        CourseToLms.find_by(course_id: course_id, lms_id: lms_id)
      end

      def assignment_exists?(course_to_lms, assignment_name, external_assignment_id)
        Assignment.exists?(course_to_lms_id: course_to_lms.id, name: assignment_name, external_assignment_id: external_assignment_id)
      end

      def validate_ids!
        required_params = [:name, :external_assignment_id, :course_id, :lms_id]
        missing_params = required_params.select { |param| params[param].blank? }
        
        if missing_params.any?
          render json: { error: 'Params required: ' + missing_params.join(", ") }, status: :bad_request
          return
        end
      
        # Validate that course_id and lms_id are integers
        unless params[:course_id].to_s.match?(/\A\d+\z/) && params[:lms_id].to_s.match?(/\A\d+\z/)
          render json: { error: 'course_id and lms_id must be integers' }, status: :bad_request
          return
        end
      end
      
    end
  end
end
