require 'rails_helper'
module Api
  module V1
    RSpec.describe AssignmentsController, type: :request do
      let(:mock_course_id) { 1 }
      let(:mock_lms_id) { 1 }

      describe "GET /api/v1/courses/:course_id/lmss/:lms_id/assignments" do
        it "throws a 501 error" do
          get "/api/v1/courses/#{mock_course_id}/lmss/#{mock_lms_id}/assignments"
          expect(response).to have_http_status(501)
        end
      end

      describe "POST /api/v1/courses/:course_id/lmss/:lms_id/assignments" do
        it "throws a 501 error" do
          post "/api/v1/courses/#{mock_course_id}/lmss/#{mock_lms_id}/assignments"
          expect(response).to have_http_status(501)
        end
      end

      describe "DELETE /api/v1/courses/:course_id/lmss/:lms_id/assignments/:id" do
        let(:mock_assignment_id) { 1 }
        it "throws a 501 error" do
          delete "/api/v1/courses/#{mock_course_id}/lmss/#{mock_lms_id}/assignments/#{mock_assignment_id}"
          expect(response).to have_http_status(501)
        end
      end
    end
  end
end
