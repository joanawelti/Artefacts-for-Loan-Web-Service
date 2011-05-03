require 'spec_helper'

describe PagesController do

  describe "GET 'home'" do
    describe "as a non-logged in user" do
      it "should redirect to the loggin page" do
        get :home
        response.should redirect_to(login_path)
      end
    end
    
    describe "as a logged in user" do
      before(:each) do
        @user = test_log_in(Factory(:user))
      end
      
      it "should be successful" do
        get :home
        response.should be_success
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
  end

end
