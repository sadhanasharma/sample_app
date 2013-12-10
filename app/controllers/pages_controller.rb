class PagesController < ApplicationController 


	def about
		@title = "About"
	end
	
	def home
		@title ="Home"
		@micropost = Micropost.new if signed_in?
	end

	def contact
		@title ="Contact"
	end
	def help
		@title ="Help"
	end

end

