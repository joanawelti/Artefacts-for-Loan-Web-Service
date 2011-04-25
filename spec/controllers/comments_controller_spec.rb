require 'spec_helper'

describe CommentsController do
  
  render_views
  
  describe "GET 'new'" do
    describe "as a non-logged in user" do
    
      it "should deny access" do
        get :new
        response.should redirect_to(login_path)
      end
    end
    
    describe "as a logged in user" do
      before(:each) do
        @user = test_log_in(Factory(:user))
      end
    
      it "should be successful" do
        get :new
        response.should be_success
      end
    
    end
  
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @user = Factory(:user)
      @owner = Factory(:user, :email => Factory.next(:email))
      @artefact = Factory(:artefact, :user => @owner)
    end

    describe "as a non-logged in user" do
      
      it "should deny access" do
        post :create, :comment => { :content => "Bla", :artefact_id => 1 }
        response.should redirect_to(login_path)
      end
      
    end

    describe "as a logged in user" do
      before(:each) do
        test_log_in(@user)
      end
      
      describe "failure because no artefact present" do

        before(:each) do
          @attr = { :content => "Bla", :artefact_id => "" }
        end

        it "should not create a comment" do
          lambda do
            post :create, :comment => @attr
          end.should_not change(Comment, :count)
        end

        it "should render the home page" do
          post :create, :comment => @attr
          response.should render_template('pages/home')
        end
      end
    
      describe "failure because no artefact present" do

        before(:each) do
          @attr = { :content => "", :artefact_id => @artefact.id }
        end

        it "should not create a comment" do
          lambda do
            post :create, :comment => @attr
          end.should_not change(Comment, :count)
        end

        it "should render the new comment page" do
          post :create, :comment => @attr
          response.should render_template('new')
        end
      end

      describe "success" do

        before(:each) do
          @attr = { :content => "Test comment", :artefact_id => @artefact.id }
        end

        it "should create a comment" do
          lambda do
            post :create, :comment => @attr
          end.should change(Comment, :count).by(1)
        end

        it "should redirect to the artefact's page" do
          post :create, :comment => @attr
          response.should redirect_to(artefact_path(@artefact))
        end

        it "should have a flash message" do
          post :create, :comment => @attr
          flash[:success].should =~ /created/i
        end
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    
    describe "as a non-logged in user" do
      it "should deny access" do
        delete :destroy, :id => 1
        response.should redirect_to(login_path)
      end
    end
    
    describe "as a logged in user" do
      
      before(:each) do
        @user = test_log_in(Factory(:user))
        @artefact = Factory(:artefact, :user => @user)
      end

      describe "for an unauthorized user" do

        before(:each) do
          wrong_user = Factory(:user, :email => Factory.next(:email))
          @comment = Factory(:comment, :user => wrong_user, :artefact => @artefact)
        end

        it "should deny access" do
          delete :destroy, :id => @comment
          response.should redirect_to(root_path)
        end
      end

      describe "for an authorized user" do

        before(:each) do
          @comment = Factory(:comment, :user => @user, :artefact => @artefact)
        end

        it "should destroy the micropost" do
          lambda do 
            delete :destroy, :id => @comment
          end.should change(Comment, :count).by(-1)
        end
      end
    end
  end
  
end