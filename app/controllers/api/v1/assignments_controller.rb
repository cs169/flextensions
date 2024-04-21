module Api
  module V1
    class AssignmentsController < ApplicationController
      before_action :validate_ids!, only: [:create]

      def index
        render json: 'not yet implemented', status: 501
      end

      # POST /courses/:course_id/lms/:lms_id/assignments
      def create
        course_to_lms = fetch_course_to_lms(params[:course_id], params[:lms_id])
        return unless course_to_lms

        return if assignment_exists?(course_to_lms, params[:name], params[:external_assignment_id])

        create_and_render_assignment(course_to_lms, params[:name], params[:external_assignment_id])
      end

      def destroy
        render json: 'not yet implemented', status: 501
      end

      private

      def fetch_course_to_lms(course_id, lms_id)
        course_to_lms = CourseToLms.find_by(course_id: course_id, lms_id: lms_id)
        unless course_to_lms
          render json: { error: 'No such Course_LMS association' }, status: :not_found
        end
        course_to_lms
      end

      def assignment_exists?(course_to_lms, assignment_name, external_assignment_id)
        existing_assignment = Assignment.find_by(course_to_lms_id: course_to_lms.id, name: assignment_name, external_assignment_id: external_assignment_id)
        if existing_assignment
          render json: { message: 'Record already exists' }, status: :ok
          return true
        end
        false
      end

      def create_and_render_assignment(course_to_lms, assignment_name, external_assignment_id)
        assignment = Assignment.new(course_to_lms_id: course_to_lms.id, name: assignment_name, external_assignment_id: external_assignment_id)
        if assignment.save
          render json: assignment, status: :created
        else
          render json: assignment.errors, status: :unprocessable_entity
        end
      end

      def validate_ids!
        if params[:name].blank? || params[:external_assignment_id].blank? || params[:course_id].blank? || params[:lms_id].blank?
          render json: { error: 'Params required' }, status: :bad_request
        end
      end
    end
  end
end
