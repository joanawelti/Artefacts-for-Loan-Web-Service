require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
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
  end
  
  describe "GET 'edit'" do
    
    before(:each) do
      @user = Factory(:user)
    end
  
    it "should include the user's userid" do
      get :edit, :id => @user
      response.should have_selector("h1", :content => @user.userid)
    end
  
    it "should include the user's firstname" do
      get :edit, :id => @user
      response.should have_selector("h1", :content => @user.firstname)
    end
  
    it "should include the user's lastname" do
      get :edit, :id => @user
      response.should have_selector("h1", :content => @user.lastname)
    end
  
    it "should include the user's address" do
      get :edit, :id => @user
      response.should have_selector("h1", :content => @user.address)
    end
  
    pending "should include the user's location" do
      get :edit, :id => @user
      response.should have_selector("h1", :content => @user.locator)
    end
  
    it "should include the user's mobile number" do
      get :edit, :id => @user
      response.should have_selector("h1", :content => @user.mobile)
    end
  
    it "should include the user's email" do
      get :edit, :id => @user
      response.should have_selector("h1", :content => @user.email)
    end
  end
  
  describe "POST 'create'" do

    describe "failure" do

        before(:each) do
          @attr = { :firstname => "", 
                    :lastname => "", 
                    :email => "", 
                    :address => "", 
                    :city => "", 
                    :postcode => "", 
                    :country => "", 
                    :mobile => "",
                    :password => "", 
                    :password_confirmation => "" }
        end

        it "should not create a user" do
          lambda do
            post :create, :user => @attr
          end.should_not change(User, :count)
        end

        it "should have the right title" do
          post :create, :user => @attr
          response.should have_selector("title", :content => "Registration")
        end

        it "should render the 'new' page" do
          post :create, :user => @attr
          response.should render_template('new')
        end
      end
    end
    
    describe "success" do

          before(:each) do
            @attr = { :firstname => "Example", 
                      :lastname => "User", 
                      :email => "user@example.com", 
                      :address => "Examplestreet 24", 
                      :city => "Aberdeen", :postcode => "1WU 24AB", 
                      :country => "UK", 
                      :mobile => "07757427217",
                      :password => "passwordForExample", 
                      :password_confirmation => "passwordForExample" }
          end

          it "should create a new user" do
            lambda do
              post :create, :user => @attr
            end.should change(User, :count).by(1)
          end

          it "should redirect to the user show page" do
            post :create, :user => @attr
            response.should redirect_to(user_path(assigns(:user)))
          end 
          
          it "should have a welcome message" do
            post :create, :user => @attr
            flash[:success].should =~ /Registration was successful/i
          end
             
      end
  
end
