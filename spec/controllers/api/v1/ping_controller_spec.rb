require 'rails_helper'
module API
  module V1
    describe PingController do
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
