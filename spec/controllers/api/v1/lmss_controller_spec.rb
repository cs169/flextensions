require 'rails_helper'
module Api
  module V1
    describe LmssController do
      let(:mock_course_id) { 16 }
      let(:mock_course_name) { 'testCourseName' }
      describe 'create' do
        it 'throws a 501 error' do
          post :create, params: {
            course_id: :mock_course_id,
            name: :mock_course_name,
          }
          expect(response.status).to eq(501)
        end

        it 'throws a 401 error if the name is not specified' do
          post :create, params: {
            course_id: :mock_course_id,
          }
          expect(response.status).to eq(401)
          expect(response.body).to eq('name parameter is required')
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
