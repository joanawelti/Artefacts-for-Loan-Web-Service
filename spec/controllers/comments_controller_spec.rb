require 'spec_helper'

describe CommentsController do
  
  render_views
  
  
  describe "POST 'create'" do
    
    before(:each) do
      @user = Factory(:user)
      @owner = Factory(:user, :email => Factory.next(:email))
      @artefact = Factory(:artefact, :user => @owner)
      @attr = { :content => "Test comment", :artefact_id => @artefact.id }
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

        it "should create a comment" do
          lambda do
            post :create, :comment => @attr
          end.should change(Comment, :count).by(1)
        end

        it "should redirect to the artefact's page" do
          post :create, :comment => @attr
          response.should redirect_to(reviews_artefact_path(@artefact))
        end

        it "should have a flash message" do
          post :create, :comment => @attr
          flash[:success].should =~ /created/i
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