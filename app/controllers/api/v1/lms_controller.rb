module Api
  module V1
    class LmsController < BaseController
      before_action :validate_name!, only: [:create]

      def create
        render :json => 'not yet implemented'.to_json, status: 501
      end

      def index
        render :json => 'not yet implemented'.to_json, status: 501
      end

      def destroy
        render :json => 'not yet implemented'.to_json, status: 501
      end

      ##
      # Validator definnitons.
      # TODO: this should be exported to its own (validator) class.
      # TODO: this validation should also check the config file for the name of lms's.
      #
      def validate_name!
        if params['name'].blank?
          render :json => 'name parameter is required', status: 401
        end
      end
    end
  end
end
