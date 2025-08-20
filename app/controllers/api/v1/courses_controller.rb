module API
  module V1
    class CoursesController < BaseController
      include ActionController::Flash

      def index
        render json: 'The index method of CoursesController is not yet implemented'.to_json, status: :not_implemented
      end

      def create
        course_name = params[:course_name]
        existing_course = Course.find_by(course_name: course_name)
        if existing_course
          render json: { message: 'A course with the same course name already exists.' }, status: :unprocessable_entity
          return
        end

        new_course = Course.create(course_name: course_name)
        new_course.save
        render_response(new_course,
                        'Course created successfully',
                        'Failed to save the new course to the database')
      end

      def destroy
        render json: 'The destroy method of CoursesController is not yet implemented'.to_json, status: :not_implemented
      end

      def add_user
        user_id = params[:user_id]
        course_id = params[:course_id]
        role = params[:role]

        # Check if the provided course_id is valid i.e. exists in courses table
        unless Course.find_by(id: course_id)
          render json: { error: 'The course does not exist.' }, status: :not_found
          return
        end

        # Check if the provided user is valid i.e. exists in users table
        unless User.find_by(id: user_id)
          render json: { error: 'The user does not exist.' }, status: :not_found
          return
        end

        # Check if the user has been already added to the course
        existing_user_to_course = UserToCourse.find_by(course_id: course_id, user_id: user_id)
        if existing_user_to_course
          render json: { error: 'The user is already added to the course.' }, status: :unprocessable_entity
          return
        end

        # Add the user to the course with the desired role
        new_user_to_course = UserToCourse.new(course_id: course_id, user_id: user_id, role: role)
        new_user_to_course.save
        render_response(new_user_to_course,
                        'User added to the course successfully.',
                        'Failed to add the user the to course.')
      end

      private

      def render_response(object, success_message, error_message)
        if object.save
          flash[:success] = success_message
          render json: object, status: :created
        else
          flash[:error] = error_message
          render json: { error: object.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
