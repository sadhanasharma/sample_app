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

	it "should have a sign up page at '/signup" do
		get '/signup'
		response.should have_selector('title', :content => "Sign up")
	end

	it "should have a sign in page at '/signin" do
		get '/signin'
		response.should have_selector('title', :content => "Sign in")
	end


	it "should have  a help page at '/Help'" do

		get '/help'
		response.should have_selector('title', :content => "Help")
	end

	it "should have right links on the layouts" do
		visit root_path
		response.should have_selector('title', :content => "Home")
		click_link "about"
		response.should have_selector('title', :content => "About" )
		click_link "contact"
		response.should have_selector('title', :content => "Contact" )

		click_link "home"
		response.should have_selector('title', :content => "Home" )

		click_link "Sign up now!"
		response.should have_selector('title', :content => "Sign up" )
		response.should have_selector('a[href="/"] > img')

	end
end
