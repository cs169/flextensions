module Api
  module V1
    class UsersController < BaseController

      def create
        render :json => 'the create method of UsersController is not yet implemented'.to_json, status: 501
      end
  
      def index
        render :json => 'the index method of UsersController is not yet implemented'.to_json, status: 501
      end
  
      def destroy
        render :json => 'the destroy method of UsersController is not yet implemented'.to_json, status: 501
      end
    end
  end
end
