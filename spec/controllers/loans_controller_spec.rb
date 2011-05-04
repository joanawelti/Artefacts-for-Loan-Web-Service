require 'spec_helper'

describe LoansController do
  
  before(:each) do
    @loan_start = get_loan_start_date
    @loan_end = get_loan_end_date(@loan_start)
  end

  describe "access control" do

    it "should require logging in for creating a loan" do
      post :create
      response.should redirect_to(login_path)
    end

    it "should require logging in for destroying a loan" do
      delete :destroy, :id => 1
      response.should redirect_to(login_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = Factory(:user)
      test_log_in(@user)
      
      @owner = Factory(:user, :email => Factory.next(:email))
      @artefact = Factory(:artefact, :user => @owner) 
    
      @attr = { :artefact_id => @artefact.id, :loan_start => @loan_start, :loan_end => @loan_end }
    end

    context "no active loan for the artefact" do
      it "should create a loan" do
        lambda do
          post :create, :loan => @attr
        end.should change(Loan, :count).by(1)
      end

      it "should have a flash message" do
        post :create, :loan => @attr
        flash[:success].should =~ /successfully made a request to loan artefact/i
      end

      it "should redirect to the home page" do
        post :create, :loan => @attr
        response.should redirect_to(root_path)
      end
    end
    
    context "active loans for the artefact exist already" do
      before(:each) do
        @second_user = Factory(:user, :email => Factory.next(:email))
        @loan = Factory(:loan, :user => @second_user, :artefact => @artefact)
      end
      
      it "should not create a loan" do
        lambda do
          post :create, :loan => @attr
        end.should_not change(Loan, :count)
      end
    end
    
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @owner = Factory(:user, :email => Factory.next(:email))
      @artefact = Factory(:artefact, :user => @owner)
    end
    
    describe "for an unauthorized users" do
      before(:each) do
        @user = test_log_in(Factory(:user))
        @user.loan!(@artefact, @loan_start, @loan_end)
        @loan = @user.loans.find_by_artefact_id(@artefact)
      end
    
      it "should not be possible for the loaner to end the loan" do
        delete :destroy, :id => @loan
        response.should redirect_to(root_path)
      end
      
    end
    
    describe "for the owner of the loaned artefact" do
      before(:each) do
        @user = Factory(:user, :email => Factory.next(:email))
        @loan = Factory(:loan, :user => @user, :artefact => @artefact)
        test_log_in(@owner)
      end

      it "should unloan the artefact" do
        delete :destroy, :id => @loan
        @user.loaned?(@artefact).should be_false
      end
      
      it "should have a flash message" do
        delete :destroy, :id => @loan
        flash[:success].should =~ /Loan successfully ended/i
      end
      
    end
  end
end
