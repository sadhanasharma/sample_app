require 'spec_helper'

describe UsersController do
		
		it "should have a sign up page at '/signup" do
		get 'new'
		response.should be_success
	end

end
