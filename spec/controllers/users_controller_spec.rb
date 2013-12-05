require 'spec_helper'

describe UsersController do

	it "GET 'new'" do
		get :new
		response.should be_success
	end

	describe "GET 'show'" do
		before(:each) do
			@user = Factory(:user)
		end

		it "should be successful" do
			get :show, :id => @user
			response.should be_success
		end

		it "show finds the right user" do
			get :show , :id => @user
			assigns(:user).should == @user	  
		end
	end
end
