require 'spec_helper'

describe ArtefactsController do
  render_views

  describe "GET index" do
    
  end
  
  describe "GET new" do
    
    describe "as a non-logged-in user" do
      it "should deny access" do
        get :new
        response.should redirect_to(login_path)
      end
    end
    
    describe "as a logged in user" do
      
      before(:each) do
        @user = Factory(:user, :email => "john2@example.com")
        test_log_in(@user)
      end
      
      
      it "should be successful" do
        get :new
        response.should be_success
      end
      
       it "should have the right title" do
          get :new
          response.should have_selector("title", :content => "New Artefact")
        end
    end
    
  end
  
  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(login_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(login_path)
    end
  end
  
  describe "POST 'create'" do

      before(:each) do
        @user = test_log_in(Factory(:user))
      end

      describe "failure" do

        before(:each) do
          @attr = { :name => "", :description => "Example artefact" }
        end

        it "should not create an artefact" do
          lambda do
            post :create, :artefact => @attr
          end.should_not change(Artefact, :count)
        end

        pending "should render the home page" do
          post :create, :artefact => @attr
          response.should render_template('pages/home')
        end
      end

      describe "success" do

        before(:each) do
          @attr = { :name => "Artefact", :description => "Example artefact" }
        end

        it "should create a artefact" do
          lambda do
            post :create, :artefact => @attr
          end.should change(Artefact, :count).by(1)
        end

        pending "should redirect to the home page" do
          post :create, :artefact => @attr
          response.should redirect_to(root_path)
        end

        it "should have a flash message" do
          post :create, :artefact => @attr
          flash[:success].should =~ /successfully/i
        end
      end
   
  end

    
    describe "DELETE 'destroy'" do
        describe "for an unauthorized user" do

          before(:each) do
            @user = Factory(:user)
            wrong_user = Factory(:user, :email => Factory.next(:email))
            test_log_in(wrong_user)
            @artefact = Factory(:artefact, :user => @user)
          end

          it "should deny access" do
            delete :destroy, :id => @artefact
            response.should redirect_to(root_path)
          end
        end

        describe "for an authorized user" do
          
          before(:each) do
            @user = test_log_in(Factory(:user))
            @artefact = Factory(:artefact, :user => @user)
          end

          it "should destroy the micropost" do
            lambda do
              delete :destroy, :id => @artefact
            end.should change(Artefact, :count).by(-1)
          end
        end
    end
    
    
    describe "GET 'show'" do
      
      before(:each) do
        @user = test_log_in(Factory(:user))
        @artefact = Factory(:artefact, :user => @user)
      end
      
      it "should have a profile image" do
          get :show, :id => @artefact
          response.should have_selector("img", :class => "artefact_image")
      end
      
      it "should show the artefact's comments" do
        c1 = Factory(:comment, :user => @user, :artefact => @artefact ,:content => "Foo bar")
        c2 = Factory(:comment, :user => @user, :artefact => @artefact, :content => "Baz quux")
        get :show, :id => @artefact
        response.should have_selector("span.content", :content => c1.content)
        response.should have_selector("span.content", :content => c2.content)
      end
    end
  
    
    
end
