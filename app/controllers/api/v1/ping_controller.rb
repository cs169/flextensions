module Api
  module V1
    class PingController < BaseController
      def ping
        render :json => 'pong'.to_json
      end
    end
  end
end
