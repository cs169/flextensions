require 'rails_helper'
require 'byebug'
module Api
  module V1
    describe ExtensionsController do
      #Log in user before accessing any controller resources.
      before do 
        session[:user_id] = 213 # Manually set session
      end
      describe "POST /api/v1/courses/:course_id/lmss/:lms_id/assignments/:assignment_id/extensions" do
        before(:all) do
          load "#{Rails.root}/db/seeds.rb"
          @course =  Course.take
          @assignment = Assignment.take
          @extension = Extension.take
          @lms = Lms.take
          @course_to_lms = CourseToLms.find(@assignment.course_to_lms_id)
          @mock_student_uid = 123
          @mock_new_due_date = '2024-04-16T16:00:00Z'
          @auth_token = 'some_valid_token'
          @mock_assignments_url = "#{ENV['CANVAS_URL']}/api/v1/courses/#{@course_to_lms.external_course_id}/assignments"
          @mock_override_url = "#{@mock_assignments_url}/#{@assignment.external_assignment_id}/overrides"
        end

        context "with valid parameters" do
          it "creates a new extension and returns a success status" do
            stub_request(:post, @mock_override_url).
              with(
                body: {
                  assignment_override: hash_including({
                    "due_at" => @mock_new_due_date,
                    "lock_at" => @mock_new_due_date,
                    "student_ids" => [@mock_student_uid.to_s],
                    "title" => "#{@mock_student_uid} extended to #{@mock_new_due_date}",
                  })
                },
                headers: { Authorization: "Bearer #{@auth_token}" }
              ).to_return(
                status: 200,
                body: { due_at: @mock_new_due_date, id: "3333" }.to_json,
                headers: {},
              )
            stub_request(:get, "#{@mock_assignments_url}/#{@assignment.external_assignment_id}")
              .to_return(
                status: 200,
                body: { due_at: '2024-04-13T16:00:00Z' }.to_json,
                headers: {},
              )

            request.headers.merge!({'Authorization': @auth_token})
            post :create, params: {
                course_id: @course.id,
                lms_id: @lms.id,
                assignment_id: @assignment.id,
                student_uid: @mock_student_uid,
                new_due_date: @mock_new_due_date,
              }
            expect(response).to have_http_status(:success)
          end
        end

        context "with missing parameters" do
          it "raises an error" do
            stub_request(:post, @mock_override_url).
              to_return(status: 400)

            stub_request(:get, "#{@mock_assignments_url}/#{@assignment.external_assignment_id}")
              .to_return(
                status: 200,
                body: { due_at: '2024-04-13T16:00:00Z' }.to_json,
                headers: {},
              )

            expect { post(:create, params: {
                course_id: @course.id,
                lms_id: @lms.id,
                assignment_id: @assignment.id,
              }) }.to raise_error(FailedPipelineError)
          end
        end

        context "when canvas returns 500" do
          it "returns a 500 status" do
            stub_request(:post, @mock_override_url).
              to_return(
                status: 500,
                body: { errors: ["unknown student ids"] }.to_json,
              )

            stub_request(:get, "#{@mock_assignments_url}/#{@assignment.external_assignment_id}")
              .to_return(
                status: 200,
                body: { due_at: '2024-04-13T16:00:00Z' }.to_json,
                headers: {},
              )

            post :create, params: {
              course_id: @course.id,
              lms_id: @lms.id,
              assignment_id: @assignment.id,
              student_uid: 9999,
              new_due_date: 7,
            }
            expect(response).to have_http_status(500)
          end
        end

        context "get assignment api call fails" do
          it "doesn't request a new extension and returns a server error" do
            stub_request(:post, @mock_override_url).
              with(
                body: hash_including({
                  due_at: @mock_new_due_date,
                  lock_at: @mock_new_due_date,
                  student_ids: [@mock_student_uid.to_s],
                  title: "#{@mock_student_uid} extended to #{@mock_new_due_date}"
                }),
                headers: { Authorization: "Bearer #{@auth_token}" }
              ).
              to_return(
                status: 200,
                body: { due_at: @mock_new_due_date, id: "3333" }.to_json,
                headers: {}
              )

            stub_request(:get, "#{@mock_assignments_url}/#{@assignment.external_assignment_id}")
              .to_return(status: 404)

            request.headers.merge!({ Authorization: @auth_token })
            post :create, params: {
              course_id: @course.id,
              lms_id: @lms.id,
              assignment_id: @assignment.id,
              student_uid: @mock_student_uid,
              new_due_date: @mock_new_due_date
            }
            expect(response).to have_http_status(:error)
          end
        end
      end
    end
  end
end
