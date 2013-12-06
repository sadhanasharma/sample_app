require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "should have right title" do
      get :new
      response.should have_selector(:title, :content => "Sign in")
    end

    describe "POST 'create'" do
      describe "failure" do
        before(:each) do
          @attr ={ :email => "", :password => ""}
        end

        it "should re-render the new page" do
          post  :create, :session => @attr
          response.should render_template('new')
        end

        it "should have the right title" do
          post :create, :session => @attr
          response.should have_selector('title' , :content => "Sign in")
        end

        it "should have and error message" do
          
        end


      end
    end

  end

end
