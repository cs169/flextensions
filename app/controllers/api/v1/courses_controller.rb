module Api
  module V1
    class CoursesController < BaseController
      canvas_test_base_url = "https://ucberkeley.test.instructure.com/"
      course_id = "1534405"
      def create
        render :json => 'The create method of CoursesController is not yet implemented'.to_json, status: 501
        # canvas_url = "{{canvas_test_base_url}}/api/v1/courses/course_id}"
        # url = URI(canvas_url)
        # response = Net::HTTP.get(url)
        # course_data = JSON.parse(response)
        # course_name = course_data['name']
        # puts "Course Name: #{course_name}"
      end

      def index
        # canvas_url = "{{canvas_test_base_url}}/api/v1/courses}"
        # response = Net::HTTP.get(canvas_url.host, canvas_url.port)
        # course_data = JSON.parse(response)
        # course_data.each do |course|
        #   course_name = course['name']
        #   puts "Course Name: #{course_name}"
        # end
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
