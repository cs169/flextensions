require 'rails_helper'
require 'byebug'
module Api
  module V1
    RSpec.describe ExtensionsController do


      describe "POST /api/v1/courses/:course_id/lmss/:lms_id/assignments/:assignment_id/extensions" do

        before(:all) do
          load "#{Rails.root}/db/seeds.rb" 
          @course =  Course.take
          @assignment = Assignment.take
          @extension = Extension.take
          @lms = Lms.take
          @course_to_lms = CourseToLms.where(lms_id: @lms.id, course_id: @course.id).take
          @mock_student_uid = 123
          @mock_new_due_date = '2024-04-16T16:00:00Z'

          @auth_token = 'some_valid_token'

          puts @course.id
        end

        context "with valid parameters" do

          it "creates a new extension and returns a success status" do
  
            # stub proper extension request
            stub_request(:post, "#{ENV['CANVAS_URL']}/api/v1/courses/#{@course_to_lms.external_course_id}/assignments/#{@assignment.external_assignment_id}/overrides").
         with(
           body: hash_including({"due_at"=>"#{@mock_new_due_date}", "lock_at"=>"#{@mock_new_due_date}", "student_ids"=>["#{@mock_student_uid}"],
            "title"=>"#{@mock_student_uid} extended to #{@mock_new_due_date}"}),
            headers: {"Authorization"=> "Bearer #{@auth_token}"}
           ).
          to_return(status: 200, body: {"due_at"=>@mock_new_due_date, "id"=>"3333"}.to_json, headers: {})

          stub_request(:get, "#{ENV['CANVAS_URL']}/api/v1/courses/#{@course_to_lms.external_course_id}/assignments/#{@assignment.external_assignment_id}")
            .to_return(status: 200, body: {"due_at"=> '2024-04-13T16:00:00Z'}.to_json, headers: {})
            
          request.headers.merge!({'Authorization': @auth_token})
          post :create, params: {
              "course_id"=> @course.id, "lms_id"=> @lms.id, "assignment_id"=> @assignment.id, "student_uid"=>@mock_student_uid, "new_due_date"=>@mock_new_due_date
            }
            #post "/api/v1/courses/#{mock_course_id}/lmss/1/assignments/#{mock_assignment_id}/extensions", params: { student_uid: mock_student_uid, new_due_date: mock_new_due_date }#, headers: { 'Authorization' => auth_token }
            expect(response).to have_http_status(:success)
            puts response.body
          end
        end

        context "with invalid parameters" do
          it "returns an error status" do
            stub_request(:post, "#{ENV['CANVAS_URL']}/api/v1/courses/#{@course_to_lms.external_course_id}/assignments/#{@assignment.external_assignment_id}/overrides").
            to_return(status: 400)
            expect {post :create,
              params: {"course_id"=> @course.id, "lms_id"=> @lms.id, "assignment_id"=> @assignment.id}
          }.to raise_error(FailedPipelineError)
          end
        end
      end


      #TODO: Test get/delete

      # describe "GET /api/v1/courses/:course_id/lmss/:lms_id/assignments/:assignment_id/extensions" do
      #   it "returns a list of extensions" do
      #     get "/api/v1/courses/#{mock_course_id}/lmss/1/assignments/#{mock_assignment_id}/extensions", 
      #         headers: { 'Authorization' => auth_token }
      #     expect(response).to have_http_status(:success)
      #     expect(JSON.parse(response.body)).to be_an_instance_of(Array)
      #   end
      # end

      # describe "DELETE /api/v1/courses/:course_id/lmss/:lms_id/assignments/:assignment_id/extensions/:id" do
      #   it "deletes an extension and returns a success status" do
      #     delete "/api/v1/courses/#{mock_course_id}/lmss/1/assignments/#{mock_assignment_id}/extensions/#{mock_extension_id}", 
      #            headers: { 'Authorization' => auth_token }
      #     expect(response).to have_http_status(:success)
      #   end
      # end
    end
  end
end