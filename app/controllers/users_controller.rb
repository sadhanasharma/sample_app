class UsersController < ApplicationController

	def show
		@user = User.find(params[:id])
		@title = @user.name
	end

	def new
		@user = User.new
		@title = "Sign up"
	end

	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			redirect_to @user,  :flash => { :success =>  "Welcome to the sample app !"}

		else
			@title = "Sign up"
			render 'new'
		end
	end

	def edit
		@title ="Edit User"
		@user = User.find_by_id(params[:id])
	end

	def update
		@user = User.find_by_id(params[:id])
		if @user.update_attributes(user_params)
			redirect_to @user , :flash => { :success =>  "Profile updated."}
		else
			@title = "Edit User"
			render 'edit'
		end
	end

	def user_params
		params.require(:user).permit(:name, :email, :password, :salt, :encrypted_password)
	end

end

