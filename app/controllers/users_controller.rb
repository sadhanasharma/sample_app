class UsersController < ApplicationController
	before_filter :authenticate, :only => [:edit , :update, :index , :destroy]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user, :only => :destroy
	
	def index		
		@title = "All users"
		@users = User.paginate(:page => params[:page] )		
	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(:page => params[:page])
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
		params.require(:user).permit(:name, :email, :password, :salt, :encrypted_password, :admin)
	end


	def correct_user
		@user = User.find_by_id(params[:id])
		current_user == @user ? @user : redirect_to(root_path)
	end

	def destroy
		User.find(params[:id]).destroy
		redirect_to users_path , :flash => { :success => "User destroyed !"}
	end

	def admin_user
		user = User.find(params[:id])
		redirect_to root_path if (!current_user.admin?   || current_user == user)
	end
end
