require 'rails_helper'
module Api
  module V1
    RSpec.describe ExtensionsController, type: :request do
      let(:mock_course_id) { 16 }
      let(:mock_assignment_id) { 9 }
      let(:mock_extension_id) { 5 }
      let(:mock_student_uid) { 123 }
      let(:mock_new_due_date) { '2024-04-16T16:00:00Z' }

      let(:auth_token) { 'Bearer some_valid_token' }

      describe "POST /api/v1/courses/:course_id/lmss/:lms_id/assignments/:assignment_id/extensions" do
        context "with valid parameters" do
          it "creates a new extension and returns a success status" do
            post "/api/v1/courses/#{mock_course_id}/lmss/1/assignments/#{mock_assignment_id}/extensions", 
              params: { student_uid: mock_student_uid, new_due_date: mock_new_due_date },
              headers: { 'Authorization' => auth_token }
            expect(response).to have_http_status(:success)
          end
        end

        context "with invalid parameters" do
          it "returns an error status" do
            post "/api/v1/courses/#{mock_course_id}/lmss/1/assignments/#{mock_assignment_id}/extensions",
              params: {}, 
              headers: { 'Authorization' => auth_token }
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      describe "GET /api/v1/courses/:course_id/lmss/:lms_id/assignments/:assignment_id/extensions" do
        it "returns a list of extensions" do
          get "/api/v1/courses/#{mock_course_id}/lmss/1/assignments/#{mock_assignment_id}/extensions", 
              headers: { 'Authorization' => auth_token }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to be_an_instance_of(Array)
        end
      end

      describe "DELETE /api/v1/courses/:course_id/lmss/:lms_id/assignments/:assignment_id/extensions/:id" do
        it "deletes an extension and returns a success status" do
          delete "/api/v1/courses/#{mock_course_id}/lmss/1/assignments/#{mock_assignment_id}/extensions/#{mock_extension_id}", 
                 headers: { 'Authorization' => auth_token }
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
