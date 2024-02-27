module Api::V1
  class PingController < Api::V1::BaseController
    def ping
      render status: :ok, body: 'pong'
    end
  end
end
