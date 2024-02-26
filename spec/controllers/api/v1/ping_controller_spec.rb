require 'rails_helper'

describe Api::V1::PingController do
  it 'returns a successful response' do
    get :ping
    expect(response).to be_successful
  end

  it 'returns pong' do
    get :ping
    expect(response.body).to eq('pong')
  end
end
