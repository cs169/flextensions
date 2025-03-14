require 'rails_helper'
module Api
  module V1
    describe UsersController do
      #Log in user before accessing any controller resources.
      before do 
        session[:user_id] = 213 # Manually set session
      end
      describe 'POST #create' do
        context 'when creating a new user' do
          it 'creates the user successfully' do
            post :create, params: { email: 'test@example.com' }

            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)['message']).to eq('User created successfully')
            expect(User.exists?(email: 'test@example.com')).to be_truthy
          end
        end

        context 'when user with the same email already exists' do
          before do
            User.create(email: 'existing@example.com')
          end

          it 'returns an error message' do
            post :create, params: { email: 'existing@example.com' }

            expect(response).to have_http_status(:conflict)
            expect(JSON.parse(response.body)['message']).to eq('A user with this email already exists.')
          end
        end

        context 'when email is missing or invalid' do
          it 'returns an error when email is missing' do
            post :create, params: { email: '' }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)['message']).to eq('Failed to create user')
          end

          it 'returns an error when email is invalid' do
            # Assuming you add email format validation
            post :create, params: { email: 'invalid-email' }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)['message']).to eq('Failed to create user')
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
          delete :destroy, params: { id: 1 }
          expect(response.status).to eq(501)
        end
      end
    end
  end
end
