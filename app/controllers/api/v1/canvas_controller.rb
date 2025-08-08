module Api
  module V1
    class CanvasController < BaseController
      include TokenRefreshable

      # # TODO: Replace this with the CanvasFacade
      def example_api_call
        user = User.find_by(id: current_user_id)
        return render json: { error: 'User not found' }, status: :not_found unless user

        # Use with_valid_token to ensure we have a fresh token
        with_valid_token(user) do |token|
          # Make API call with the token
          response = Faraday.get("#{ENV.fetch('CANVAS_URL', nil)}/api/v1/users/self/activity_stream") do |req|
            req.headers['Authorization'] = "Bearer #{token}"
          end

          if response.success?
            render json: JSON.parse(response.body)
          else
            render json: { error: 'API request failed', status: response.status },
                   status: response.status
          end
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end

      private

      def current_user_id
        session[:user_id]
      end
    end
  end
end
