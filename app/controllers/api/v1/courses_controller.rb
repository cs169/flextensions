module Api
  module V1
    class CoursesController < BaseController
      require 'lms_api'

      def create
        # 0. Get the course_id from the POST endpoint url
        course_id = params[:course_id].to_i
        # 1. Get the course from canvas
        course_id = 1534405 # TODO: fix hardcode, this should come from the input in POST endpoint
        canvas_base_url = Rails.application.credentials.canvas.url # https://ucberkeley.test.instructure.com
        canvas_api_key = Rails.application.credentials.canvas.api_key
        api = LMS::Canvas.new(canvas_base_url, canvas_api_key)
        course_url = "#{canvas_base_url}/api/v1/courses/#{course_id}"
        response = api.api_get_request(course_url)
        
        # The code in the line below outputs the response to console so that the key-value pairs can be examined
        # puts response.inspect

        # 2. Store the course in the courses table
        course_name = response["name"]
        @course = Course.create(course_name: course_name)
        if @course.persisted?
          flash[:success] = "Course created successfully"
        else
          flash.now[:error] = "Failed to create course"
        end

        # 3. Implement the frontend
      end

      def index
        render :json => 'The index method of CoursesController is not yet implemented'.to_json, status: 501
        # @courses = Course.all
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
