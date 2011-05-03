require 'spec_helper'

describe ArtefactsController do
  render_views

  describe "GET index" do
    describe "as a non-logged-in user" do
      it "should deny access" do
        get :index
        response.should redirect_to(login_path)
      end
    end
    
    
    describe "as a logged in user" do
      
      before(:each) do
        @user = Factory(:user)
        @second_user = Factory(:user, :email => Factory.next(:email))
        @a1 = Factory(:artefact, :user => @user, :name => "AAA")
        @a2 = Factory(:artefact, :user => @second_user, :name => "BBB")
        @a3 = Factory(:artefact, :user => @second_user, :name => "CCC")
        
        test_log_in(@user)
      end
      
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
          get :index
          response.should have_selector("title", :content => "Artefacts")
      end
      
      it "should list all artefacts" do
        get :index
        response.should have_selector("h3", :content => @a2.artefactid)
        response.should have_selector("h3", :content => @a3.artefactid)
      end
      
      it "should not list the user's artefacts" do
        get :index
        response.should_not have_selector("h3", :content => @a1.artefactid)
      end
      
      it "should not list hidden artefacts" do
        a4 = Factory(:artefact, :user => @second_user, :name => "DDD", :visible => false)
        get :index
        response.should_not have_selector("h3", :content => a4.artefactid)
      end
        
    end
    
    describe "as a logged in administrator" do
      
      before(:each) do
        @user = Factory(:user)
        @admin = Factory(:user, :email => "admin@test.com", :administrator => true)
        test_log_in(@admin)
      end
      
      it "should display invisible artefacts" do
        a1 = Factory(:artefact, :user => @user, :name => "DDD", :visible => false)
        get :index
        response.should have_selector("h3", :content => a1.artefactid)
      end
    end
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

    end
  
    describe "GET 'reviews'" do
      
      before(:each) do
        @user = test_log_in(Factory(:user))
        @artefact = Factory(:artefact, :user => @user) 
      end

      it "should show the artefact's comments" do
        c1 = Factory(:comment, :user => @user, :artefact => @artefact ,:content => "Foo bar")
        c2 = Factory(:comment, :user => @user, :artefact => @artefact, :content => "Baz quux")
        get :reviews, :id => @artefact
        response.should have_selector("span.content", :content => c1.content)
        response.should have_selector("span.content", :content => c2.content)
      end
      
      it "should only show the artefact's comments" do
        new_user = Factory(:user, :email => Factory.next(:email))
        a2 = Factory(:artefact, :user => new_user, :name => "Other artefact")
        c1 = Factory(:comment, :user => new_user, :artefact => a2 ,:content => "Foo bar")
        get :reviews, :id => @artefact
    
        response.should_not have_selector("span.content", :content => c1.content)
      end
    
    end
    
end
