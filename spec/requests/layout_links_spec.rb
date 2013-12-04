require 'spec_helper'

describe "LayoutLinks" do
	it "should have  a home page at '/'" do

		get '/'
		have_selector('title', :content => "Home")
	end

	it "should have  a contact page at '/contact'" do

		get '/contact'
		response.should contain( "Contact")
	end

		it "should have  a contact page at '/about'" do

		get '/about'
		response.should contain( "About")
	end

end
