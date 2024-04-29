module Api
  module V1
    class AssignmentsController < ApplicationController
      before_action :validate_ids!, only: [:create]
      skip_before_action :verify_authenticity_token

      def index
        render json: { message: 'not yet implemented'} , status: 501
      end

      # POST /courses/:course_id/lms/:lms_id/assignments
      def create
        # Check if the course_to_lms association exists
        course_to_lms = CourseToLms.find_by(course_id: params[:course_id], lms_id: params[:lms_id])
        unless course_to_lms
          render json: { error: 'No such Course_LMS association' }, status: :not_found
          return
        end

        # Check if the assignment already exists
        if Assignment.exists?(course_to_lms_id: course_to_lms.id, name: params[:name], external_assignment_id: params[:external_assignment_id])
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
        render json: { message: 'not yet implemented'} , status: 501
      end

      private



      def validate_ids!
        begin
          params.require([:course_id, :lms_id, :name, :external_assignment_id])
        rescue ActionController::ParameterMissing => e
          render json: { error: e.message }, status: :bad_request
          return
        end
        
      
        # Validate that course_id and lms_id are integers
        unless is_valid_course_id(params[:course_id].to_i) && is_valid_lms_id(params[:lms_id].to_i)
          render json: { error: 'course_id and lms_id must be integers' }, status: :bad_request
          return
        end
      end
      
    end
  end
end
