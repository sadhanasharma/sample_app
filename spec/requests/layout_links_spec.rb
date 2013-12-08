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

	describe "when not signed in" do
		it "should have a signin links" do
			visit root_path
			response.should have_selector("a", :href => signin_path, :content => "Sign in")
		end
	end

	describe "when signed in" do

		before(:each) do
			@user = Factory(:user)
			visit signin_path
			fill_in :email, :with => @user.email
			fill_in :password, :with => @user.password
			click_button
		end

		it "should have a sign out link" do
			visit root_path
			response.should have_selector("a", :href => signout_path, :content => "Sign out")
		end

		it "should have a profile link" do
			visit root_path
			response.should have_selector("a", :href => user_path(@user) , :content => "Profile")
		end

		it "should have a settings link" do
			visit root_path
			response.should have_selector("a", :href => edit_user_path(@user) , :content => "Settings")
		end

		it "should have a users link" do
		  visit root_path
		  response.should have_selector('a', :href => users_path, :content => "Users")
		end
	end

	describe "authorization" do

		describe "for non-signed-in users" do

			before(:each) do
				@user = Factory(:user)
			end

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(@user)
					fill_in "Email",    with:  @user.email
					fill_in "Password", with:  @user.password
					click_button "Submit"
				end

				describe "after signing in" do
					it "should render the desired protected page" do
						response.should have_selector("title", :content => 'Edit User')
					end
				end
			end
		end
	end
end
