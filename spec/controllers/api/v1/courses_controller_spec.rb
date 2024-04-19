require 'rails_helper'
module Api
  module V1
    describe CoursesController do
      describe 'create' do
        it 'throws a 501 error' do
          post :create
          expect(response.status).to eq(501)
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
        it 'throws a 501 error' do
          put :add_user, params: { course_id: 16, user_id: 16 }
          expect(response.status).to eq(501)
        end
      end
    end

  end
end
