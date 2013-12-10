class  MicropostsController < ApplicationController

	before_filter :authenticate
	before_filter :authorized_user, :only => :destroy


	def create
		@micropost = current_user.microposts.build(micropost_params)

		if @micropost.save
			flash[:success] = "Micropost created !"
			@feed_items = current_user.feed.paginate(:page => params[:page])
			redirect_to(root_path)
		else
			@feed_items = []
			render "pages/home"
		end
	end

	def destroy
		@micropost = Micropost.find(params[:id])
		@micropost.destroy
		redirect_to root_path, :flash => { :success => "Micropost deleted !" }
	end

	def authorized_user
		@micropost = Micropost.find(params[:id])
		redirect_to root_path unless current_user == @micropost.user
	end

	def micropost_params
		params.require(:micropost).permit(:content, :user_id)
	end
end
