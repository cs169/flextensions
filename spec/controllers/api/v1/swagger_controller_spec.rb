require 'rails_helper'
module Api
  module V1
    describe SwaggerController do
      let(:fileContents) { '{}' }

      before do
        allow(Rails).to receive(:root).and_return('')
        allow(File).to receive(:read).with('app/assets/swagger/swagger.json').and_return(fileContents)
      end

      it 'returns the file content' do
        get :read
        expect(response.body).to eq(fileContents)
      end
    end
  end
end
