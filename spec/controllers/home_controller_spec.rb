require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    context 'when no user is logged in' do
      it 'renders the index page' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end
    end

    context 'when user is logged in' do
      before { session[:user_id] = '12345' }

      it 'redirects to courses_path' do
        get :index
        expect(response).to redirect_to(courses_path)
      end
    end
  end
end
