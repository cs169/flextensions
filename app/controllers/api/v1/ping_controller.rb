class Api::V1::PingController < ApplicationController
  def ping
    render status: :ok, body: 'pong'
  end
end
