class SessionController < ApplicationController
    def create
        # Replace with your manually generated Canvas API token
        manual_token = ENV['MANUAL_TOKEN']
    
        # Fetch user profile from Canvas API using the token
        response = Faraday.get("https://ucberkeleysandbox.instructure.com/api/v1/users/self?include[]=email") do |req|
            req.headers["Authorization"] = "Bearer #{manual_token}"
          end
          
    
        if response.success?
            user_data = JSON.parse(response.body)
            find_or_create_user(user_data, manual_token)
            redirect_to offerings_path, notice: "Logged in!"
        else
            redirect_to root_path, alert: "Authentication failed. Invalid token."
        end
    end

    private def find_or_create_user(user_data, token)
        puts(user_data)
        # Find or create user in database
        user = User.find_or_initialize_by(canvas_uid: user_data["id"])
        user.assign_attributes(
          email: user_data["primary_email"] || "test@berkeley.edu",
          name: user_data["name"],
          canvas_token: token, # Store the token to use for API requests
          #canvas_token_expires_at: Time.current + 1.hours 
        )
        user.save!
  
        # Store user ID in session for authentication
        session[:user_id] = user.id
    end
  
    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: "Logged out!"
    end
  end
  



