require 'json'

module API
  module V1
    class SwaggerController < BaseController
      def read
        specFile = File.read("#{Rails.root}app/assets/swagger/swagger.json")
        render json: specFile
      end
    end
  end
end
