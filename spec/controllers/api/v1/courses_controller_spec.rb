require 'rails_helper'
module Api
  module V1
    describe CoursesController do
      before do 
        session[:user_id] = 213 # Manually set session
      end
      describe 'POST #create' do
        context 'when the new course is successfully created' do
          let(:course_name) { 'New Course' }

          it 'creates and saves a new course' do
            post :create, params: { course_name: course_name }

            expect(response).to have_http_status(:created)
            expect(Course.find_by(course_name: course_name)).to be_present
            expect(flash[:success]).to eq('Course created successfully')
            expect(response.parsed_body['course_name']).to eq('New Course')
          end
        end

        context 'when a course with the same name already exists' do
          let!(:existing_course) { Course.create(course_name: 'Existing Course') }

          it 'does not create a new course with the same name and returns an error' do
            post :create, params: { course_name: existing_course.course_name }

            expect(Course.find_by(course_name: existing_course.course_name)).to be_present
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.parsed_body).to eq({ 'message' => 'A course with the same course name already exists.' })
          end
        end
      end

      describe 'index' do
        it 'throws a 501 error' do
          get :index
          expect(response.status).to eq(501)
        end
      end

      describe 'destroy' do
        it 'throws a 501 error' do
          delete :destroy, params: { id: 16 }
          expect(response.status).to eq(501)
        end
      end

      describe 'add_user' do
        let(:test_course) { Course.create(course_name: 'Test Course') }
        let(:test_user) { User.create!(email: 'testuniqueuser@example.com') }

        context 'Provided parameters are valid' do
          it 'adds an existing user to an existing course' do
            post :add_user, params: { course_id: test_course.id, user_id: test_user.id, role: 'ta' }
            expect(response).to have_http_status(:created)
            expect(flash['success']).to eq('User added to the course successfully.')
          end
        end

        context 'Provided parameter are invalid' do
          it 'returns an error if course is not existed in the courses table' do
            post :add_user, params: { course_id: 123_456, user_id: test_user.id, role: 'ta' }
            expect(response).to have_http_status(:not_found)
            expect(response.parsed_body['error']).to eq('The course does not exist.')
          end

          it 'returns an error if user is not existed in the users table' do
            post :add_user, params: { course_id: test_course.id, user_id: 123_456, role: 'ta' }
            expect(response).to have_http_status(:not_found)
            expect(response.parsed_body['error']).to eq('The user does not exist.')
          end

          it 'returns an error if the user is already associated with the course' do
            post :add_user, params: { course_id: test_course.id, user_id: test_user.id, role: 'student' }
            post :add_user, params: { course_id: test_course.id, user_id: test_user.id, role: 'student' }
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.parsed_body['error']).to eq('The user is already added to the course.')
          end
        end
      end
    end
  end
end
