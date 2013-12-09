# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Micropost do
	before(:each) do
		@user = Factory(:user)
		@attr = {:content => 'Lorem ipsum dolor sit amet.'}
		@micropost = @user.microposts.create!(@attr)
	end
	it "should create a new instance with valid attribute" do
		@user.microposts.create!(@attr)
	end
	it "should respond to 'content'" do
		@micropost.should respond_to(:content)
	end

	it "should respond to 'user_id'" do
		@micropost.should respond_to(:user_id)
	end

	describe "when user_id is not present" do
		before { @micropost.user_id = nil }
		it { should_not be_valid }
	end

	describe "user association" do
		before(:each) do
			@micropost =   @user.microposts.create!(@attr)
		end
		it "it should have right associated user" do
			@micropost.should respond_to(:user)
		end

		it "should have the right associate user" do
			@micropost.user_id.should == @user.id
			@micropost.user.should == @user
		end
	end

	describe "validations" do
	  it "should have a user id" do
	  	Micropost.new(@attr).should_not be_valid	    
	  end

	  it "should require non blank content" do
	    @user.microposts.build(:content => "         ").should_not be_valid
	  end

	  it "should reject long content" do
	      @user.microposts.build(:content => "a"*141).should_not be_valid
	  end
	end
end
