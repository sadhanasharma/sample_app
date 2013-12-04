require 'spec_helper'

describe "Static Pages" do
  describe "Home Page" do
    it "Should have the content 'Sample 'App'" do
      get "/"
    response.should contain('Home') 
    end
  end
end
