require 'rails_helper'
module Api
  module V1
    describe SwaggerController do
      before do
        session[:user_id] = 213
        allow(Rails).to receive(:root).and_return('')
        allow(File).to receive(:read).with('app/assets/swagger/swagger.json').and_return(fileContents)
        # Manually set session
      end

      let(:fileContents) { '{}' }

      it 'returns the file content' do
        get :read
        expect(response.body).to eq(fileContents)
      end
    end
  end
end
