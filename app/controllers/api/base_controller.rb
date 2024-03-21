module Api
  class BaseController < ActionController::API
    before_action :accessControlAllowOrigin

    private

    def accessControlAllowOrigin
      response.set_header('Access-Control-Allow-Origin', '*')
    end
  end
end
