require 'rails_helper'
module Api
  module V1
    describe LmsController do
      let(:test_course_id) { 16 }
      describe 'create' do
        it 'throws a 501 error' do
          post :create, params: { course_id: :test_course_id }
          expect(response.status).to eq(501)
        end
      end

      describe 'index' do
        it 'throws a 501 error' do
          get :index, params: { course_id: :test_course_id }
          expect(response.status).to eq(501)
        end
      end

      describe 'destroy' do
        it 'throws a 501 error' do
          delete :destroy, params: { course_id: :test_course_id, id: 16 }
          expect(response.status).to eq(501)
        end
      end
    end
  end
end
