
require 'spec_helper'

describe "User pages" do

	it "should have the right title" do
		get :show , :id => @user
		response.should have_selector("title", :content => @user.name)
	end

	it "should have the user's name" do
		get :show, :id => @user
		response.should have_selector('h1', :content => @user.name)
	end

	it "should have a profile image" do
		get :show, :id => @user
		response.should have_selector('h1>img', :class => 'gravatar')
	end

end
