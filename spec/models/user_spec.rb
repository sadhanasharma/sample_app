# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean          default(FALSE)
#

require 'spec_helper'

describe User do

	before(:each) do
		@attr = {:name => "Example User",
			:email => "user@example.com",
			:password => "foobar",
			:password_confirmation => "foobar"
		}
	end

	it "should create a new instance of user with the valid attribute" do
		User.create!(@attr)
	end

	it "should require a name" do
		no_name_user =User.new(@attr.merge(:email => ""))
		no_name_user.should_not be_valid
	end

	it "should require a email" do
		no_name_user =User.new(@attr.merge(:name => ""))
		no_name_user.should_not be_valid
	end
	it "should reject names that are too long" do
		long_name = "a" * 51
		long_name_user =User.new(@attr.merge(:name => long_name))
		long_name_user.should_not be_valid
	end

	it "should accept valid email addreesses" do
		addresses = %w[user@foo.COM THE_US-ER@foo.bar.org first.last@foo.jp]
		addresses.each do |address|
			user =User.new(@attr.merge(:email => address))
			user.should be_valid
		end
	end

	it "should reject invalid email addresses" do
		addreesses = %w[user@foo,COM THE_US-ERfoo.bar.org first.last@foo.]

		addreesses.each do |address|
			invalid_email_user =User.new(@attr.merge(:email => address))
			invalid_email_user.should_not be_valid
		end
	end

	it "should reject duplicate email addresses" do
		User.create!(@attr)
		user_with_duplicate_email = User.new (@attr)
		user_with_duplicate_email.should_not be_valid
	end

	it "should reject email addresses identical up to case" do
		upcased_email = @attr[:email].upcase
		User.create!(@attr.merge(:email => upcased_email))
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not be_valid
	end

	describe "passwords" do

		before(:each) do
			@user = User.new(@attr)
		end

		it "should respond to microposts" do
			@user.should respond_to(:microposts)
		end

		it "should have  a password attribute" do
			@user.should respond_to(:password)
		end

		it "Should have a password confirmation attribute" do
			@user.should respond_to(:password_confirmation)
		end
	end

	describe "password validations" do
		it "should require a password" do
			User.new(@attr.merge(:password => "", :password_confirmation => "")).
			should_not be_valid
		end

		it "should require a matching password confirmation" do
			User.new(@attr.merge(:password_confirmation => "invalid")).
			should_not be_valid
		end

		it "should reject short passwords" do
			short = "a"*5
			hash = @attr.merge(:password => short, :password_confirmation => short)
			User.new(hash).should_not be_valid
		end

		it "should reject long passwords" do
			long = "a"*41
			hash = @attr.merge(:password => long, :password_confirmation => long)
			User.new(hash).should_not be_valid
		end

	end

	describe "password encryption" do
		before(:each) do
			@user = User.create!(@attr)
		end

		it "should have an encrypted password attribute" do
			@user.should respond_to(:encrypted_password)
		end

		it "should set the encrypted password attribute" do
			@user.encrypted_password.should_not be_blank
		end

		it "should respond_to salt" do
			@user.should respond_to(:salt)
		end

		describe "has_password? method" do

			it "should expect" do
				@user.should respond_to('has_password?')
			end

			it "should return true if the passwords match" do
				@user.has_password?(@attr[:password]).should be_true
			end

			it "should return false if the passwords match" do
				@user.has_password?("invalid").should be_false
			end
		end

		describe "authentication method" do

			it "should exist" do
				User.should respond_to(:authenticate)
			end

			it "should return nil on email/password mismatch" do
				User.authenticate(@attr[:email], "wrongpass").should be_nil
			end

			it "should return nil for an email address with no user" do
				User.authenticate("barfoo.com", @attr[:password]).should be_nil
			end

			it "should return the user on email/password match" do
			  User.authenticate(@attr[:email], @attr[:password]).should == @user
			end
		end
	end

	describe "admin attribute" do
		before(:each) do
		  @user = User.create!(@attr)
		end

	  it "should respond to admin" do
	    @user.should respond_to(:admin)
	  end

	  it "should not be an admin by default" do
	    @user.should_not be_admin
	  end

	  it "should be convertible to the admin" do
	    @user.toggle!(:admin)
	    @user.should be_admin
	  end
	end

	describe "micropost associations" do

		before(:each) do
		  @user = User.create(@attr)
		  @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
		  @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
		end

	  it "should have a microposts attribute" do
	    @user.should respond_to(:microposts)
	  end

	  it "should have the right microposts in right order" do
	    @user.microposts.should == [ @mp2, @mp1]
	  end

	  it "should destroy microposts for the user" do
	    @user.destroy
	    [@mp1, @mp2].each do |micropost|
	    	lambda do
	    	Micropost.find(micropost.id).should be_nil
	    end.should raise_error(ActiveRecord::RecordNotFound)
	    end
	  end
	end
end
