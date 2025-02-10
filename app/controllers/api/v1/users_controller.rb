module Api
  module V1
    class UsersController < BaseController
      include ActionController::Flash

      def create
        email = params[:email]

        # Check if the user already exists by email
        existing_user = User.find_by(email: email)
        if existing_user
          render json: { message: 'A user with this email already exists.' }, status: :conflict
          return
        end

        # Build a new user object with the given email
        new_user = User.new(email: email)

        if new_user.save
          render json: { message: 'User created successfully', user: new_user }, status: :created
        else
          render json: { message: 'Failed to create user', errors: new_user.errors.full_messages }, status: :unprocessable_entity
        end
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
