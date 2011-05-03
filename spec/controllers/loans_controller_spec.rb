require 'spec_helper'

describe LoansController do

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
    
      @loan_start = get_loan_start_date
      @loan_end = get_loan_end_date(@loan_start)
      @attr = { :artefact_id => @artefact.id, :loan_start => @loan_start, :loan_end => @loan_end }
    end

    it "should create a loan" do
      lambda do
        post :create, :loan => @attr
      end.should change(Loan, :count).by(1)
    end
  end

  pending "DELETE 'destroy'" do

    before(:each) do
      @user = test_log_in(Factory(:user))
      @owner = Factory(:user, :email => Factory.next(:email))
      @artefact = Factory(:artefact, :user => @owner)
      @user.loan!(@artefact)
      @loan = @user.loans.find_by_loaned_id(@artefact)
    end

    it "should destroy a loan" do
      lambda do
        delete :destroy, :id => @loan
        response.should be_redirect
      end.should change(Loan, :count).by(-1)
    end
  end
end
