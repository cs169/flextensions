require 'rails_helper'
module Api
  module V1
    describe PingController do
      before do 
        session[:user_id] = 213 # Manually set session
      end
      it 'returns a successful response' do
        get :ping
        expect(response).to be_successful
      end

      it 'returns pong as json' do
        get :ping
        expect(response.body).to eq('"pong"')
      end
    end
  end
end
