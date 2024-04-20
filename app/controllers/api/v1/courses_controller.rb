module Api
  module V1
    class CoursesController < BaseController
      require 'lms_api'
      include ActionController::Flash

      def create
        course_name = params[:course_name]
        existing_course = Course.find_by(course_name: course_name)
        if existing_entry
          render json: { messgae: 'A course with the same course name already exists.'}
          return
        end

        new_course = Course.new(
          course_name: course_name
        )
        if new_course.save
          render json: new_course, status: :created
        else
          render json: new_course.errors, status: :unprocessable_entity
        end
      end

      def index
        render :json => 'The index method of CoursesController is not yet implemented'.to_json, status: 501
      end

      def destroy
        render :json => 'The destroy method of CoursesController is not yet implemented'.to_json, status: 501
      end

      def add_user
        render :json => 'The add_user method of CoursesControler us not yet implemented'.to_json, status: 501
      end
    end
  end
end
