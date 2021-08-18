class SessionsController < ApplicationController
    
    def create
       user = User.find_by(username: params[:username])
       if user&.authenticate(params[:password])
           session[:user_id] = user.id
           render json: user
       else
           render json: { errors: ["Invalid username or password", "this is in an array so it can pass RSPEC"] }, status: :unauthorized
       end
    end 

    def destroy
        if session[:user_id]
            session.destroy
            head :no_content
        else
            render json: { errors: ["Not logged in", "this is in an array so it can pass RSPEC"] }, status: :unauthorized
        end
    end
end
