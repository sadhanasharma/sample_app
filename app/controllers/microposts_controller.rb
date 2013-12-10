class  MicropostsController < ApplicationController

	before_filter :authenticate

	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created !"
			redirect_to(root_path)
		else
			render "pages/home"
		end
	end

	def destroy

	end

	def micropost_params
		params.require(:micropost).permit(:content, :user_id)
	end
end