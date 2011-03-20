require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
  
  
  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    #it "should have the right title" do
    #  get :show, :id => @user
    #  response.should have_selector("title", :content => @user.name)
    #end

    # User detail page
    it "should include the user's userid" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.userid)
    end
    
    it "should include the user's firstname" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.firstname)
    end
    
    it "should include the user's lastname" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.lastname)
    end
    
    it "should include the user's address" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.address)
    end
    
    pending "should include the user's location" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.locator)
    end
    
    it "should include the user's mobile number" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.mobile)
    end
    
    it "should include the user's email" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.email)
    end
  
  end

end
