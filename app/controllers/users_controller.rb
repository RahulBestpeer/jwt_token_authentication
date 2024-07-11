class UsersController < ApplicationController
	skip_forgery_protection
	
	rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record

	#create the user and generate jwt token 
    def create 
        user = User.create!(user_params)
        @token = encode_token(user_id: user.id)
        render json: {
            user: UserSerializer.new(user), 
            token: @token
        }, status: :created
    end

    ##Update the user using token
   	def edit 
   		render json: current_user
   	end 

   	def update 
   		# debugger
   		id = current_user.id
   		user = User.find(id)

   		if user.update(user_params)
   			render json: user
   		else 
   			render json:{error_message:"Somthing is wrong user is not update"}
   		end
   	end 


   	## destroy the user using jwt token
   	def destroy 
   		user = current_user

   		if user.destroy
   			render json:{message:"User deleted "}
   		else 
   			render json:{message:"User is not delete"}
   		end
   	end


    ## render the current user informetion
    def me 
        render json: current_user, status: :ok
    end

    ## login the user 
 	def login 

        @user = User.find_by!(username: login_params[:username])
        if @user.password == (login_params[:password])
            @token = encode_token(user_id: @user.id)
            render json: {
                user: UserSerializer.new(@user),
                token: @token
            }, status: :accepted
        else
            render json: {message: 'Incorrect password'}, status: :unauthorized
        end

    end

   	
   	## logout the user 
   	def logout 	
   		
   	end


    private
	def login_params 
        params.permit(:username, :password)
    end
    def user_params 
        params.permit(:username, :password, :bio)
    end

    def handle_invalid_record(e)
            render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end
end
