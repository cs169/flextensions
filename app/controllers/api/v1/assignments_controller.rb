module Api
  module V1
    class AssignmentsController < ApplicationController
      before_action :validate_ids!, only: [:create]

      def index
        render json: 'not yet implemented', status: 501
      end

      # POST /courses/:course_id/lms/:lms_id/assignments
      def create
        assignment_name = params[:name]
        external_assignment_id = params[:external_assignment_id]
        course_id = params[:course_id]
        lms_id = params[:lms_id]

        # Retrieve the course_to_lms entry
        course_to_lms = CourseToLms.find_by(course_id: course_id, lms_id: lms_id)

        unless course_to_lms
          render json: { error: 'Course to LMS association not found' }, status: :not_found
          return
        end

        # Check this assignment doesn't already exist
        existing_assignment = Assignment.find_by(course_to_lms_id: course_to_lms.id, name: assignment_name, external_assignment_id: external_assignment_id)
        if existing_assignment
          render json: { message: 'The assignment with the specified external ID already exists.' }, status: :ok
          return
        end

        # Create the assignment
        assignment = Assignment.new(
          course_to_lms_id: course_to_lms.id,
          name: assignment_name,
          external_assignment_id: external_assignment_id
        )

        if assignment.save
          render json: assignment, status: :created
        else
          render json: assignment.errors, status: :unprocessable_entity
        end

      end

      def destroy
        render json: 'not yet implemented', status: 501
      end

      def validate_ids!
        if params[:name].blank? || params[:external_assignment_id].blank? || params[:course_id].blank? || params[:lms_id].blank?
          render json: { error: 'Course ID, LMS ID, name, and external assignment ID are required' }, status: :bad_request
        end
      end
    end
  end
end
  