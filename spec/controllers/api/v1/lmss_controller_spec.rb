require 'rails_helper'
module API
  module V1
    describe LmssController do
      def json_response
        response.parsed_body
      end

      before do
        # Manually create a course and LMS in the database
        @course = Course.create!(course_name: 'Mock CS169 Course')
        @lms = Lms.create!(lms_name: 'Mock Canvas', use_auth_token: true)
        @external_course_id = 'mock_external_course_id'
      end

      after do
        # Clean up the specifically created data
        LmsCredential.destroy_all
        Extension.destroy_all
        Assignment.destroy_all
        CourseToLms.destroy_all
        UserToCourse.destroy_all
        Course.destroy_all
        Lms.destroy_all
        User.destroy_all
      end

      describe 'POST #create' do
        context 'when lms_id is missing' do
          it 'returns status :bad_request' do
            post :create, params: { course_id: @course.id, external_course_id: @external_course_id }
            expect(response).to have_http_status(:bad_request)
            expect(response.body).to include('param is missing or the value is empty: lms_id')
          end
        end

        context 'when course_id and lms_id are not invalid' do
          it 'returns status :bad_request' do
            post :create, params: { course_id: '-1', lms_id: '-1', external_course_id: @external_course_id }
            expect(response).to have_http_status(:bad_request)
            expect(response.body).to include('Invalid course_id or lms_id')
          end
        end

        context 'when valid parameters are provided' do
          it 'creates a new course_to_lms association and returns status :created' do
            post :create, params: { course_id: @course.id, lms_id: @lms.id, external_course_id: @external_course_id }
            expect(response).to have_http_status(:created)
            expect(json_response['course_id']).to eq(@course.id)
            expect(json_response['lms_id']).to eq(@lms.id)
          end
        end

        context 'when course_to_lms fails to save' do
          it 'returns status :unprocessable_entity' do
            allow_any_instance_of(CourseToLms).to receive(:save).and_return(false)
            post :create, params: { course_id: @course.id, lms_id: @lms.id, external_course_id: @external_course_id }
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'when course does not exist' do
          it 'returns status :not_found' do
            # Ensure that the course does not exist
            selected_course = Course.find_by(id: @course.id)
            selected_course&.destroy
            post :create, params: { course_id: @course.id, lms_id: @lms.id, external_course_id: @external_course_id }
            expect(response).to have_http_status(:not_found)
            expect(response.body).to include('Course not found')
          end
        end

        context 'when lms does not exist' do
          it 'returns status :not_found' do
            # Ensure that the LMS does not exist
            selected_lms = Lms.find_by(id: @lms.id)
            selected_lms&.destroy

            post :create, params: { course_id: @course.id, lms_id: 1, external_course_id: @external_course_id }
            expect(response).to have_http_status(:not_found)
            expect(response.body).to include('Lms not found')
          end
        end

        context 'when the association already exists' do
          it 'returns status :ok' do
            CourseToLms.create!(course_id: @course.id, lms_id: @lms.id, external_course_id: @external_course_id)
            post :create, params: { course_id: @course.id, lms_id: @lms.id, external_course_id: @external_course_id }
            expect(response).to have_http_status(:ok)
            expect(response.body).to include('The association between the specified course and LMS already exists.')
          end
        end
      end

      describe 'index' do
        it 'throws a 501 error' do
          get :index, params: { course_id: :mock_course_id }
          expect(response.status).to eq(501)
        end
      end

      describe 'destroy' do
        it 'throws a 501 error' do
          delete :destroy, params: { course_id: :mock_course_id, id: 18 }
          expect(response.status).to eq(501)
        end
      end
    end
  end
end
