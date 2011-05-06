require 'spec_helper'

describe LoansController do
  
  render_views
  
  before(:each) do
    @loan_start = get_loan_start_date
    @loan_end = get_loan_end_date(@loan_start)
    
    @user = Factory(:user)
    @owner = Factory(:user, :email => Factory.next(:email))
    @artefact = Factory(:artefact, :user => @owner)
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
    
    it "should require logging in for the loan index page" do
      get :index
      response.should redirect_to(login_path)      
    end
  end

  describe "POST 'create'" do

    before(:each) do
      test_log_in(@user)
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

    
    describe "for an unauthorized users" do
      before(:each) do
        test_log_in(@user)
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
  
  
  describe "GET index" do
    
    describe "as a non-admin user" do
      
      before(:each) do
        test_log_in(@user)
      end
      
      
      it "should redirect the home page" do
        get :index
        response.should redirect_to(root_path)
      end
        
    end
    
    describe "as a logged in administrator" do
      
      before(:each) do
        @loan = Factory(:loan, :user => @user, :artefact => @artefact, :loan_start => @loan_start, :loan_end => @loan_end)
        @admin = Factory(:user, :email => "admin@test.com", :administrator => true)
        test_log_in(@admin)
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "Active Loans")
      end
      
      it "should display all active loans" do
        a1 = Factory(:artefact, :user => @user, :name => "DDD")
        l2 = Factory(:loan, :user => @user, :artefact => a1, :loan_start => @loan_start, :loan_end => @loan_end)
        
        get :index
        response.should have_selector("h3", :content => a1.artefactid)
        response.should have_selector("h3", :content => @artefact.artefactid)
      end
    end
  end
  
  describe "GET 'reorder'" do
    
    context "as a non-admin user" do
      
      before(:each) do
        test_log_in(@user)
      end
      
      it "should redirect the home page" do
        get :index
        response.should redirect_to(root_path)
      end
        
    end
    
    context "as a logged in administrator" do
      
      before(:each) do
        @a1 = Factory(:artefact, :user => @user, :name => "DDD")
        @loan1 = Factory(:loan, :user => @user, :artefact => @artefact, :loan_start => @loan_start, :loan_end => @loan_end, :created_at => Time.now - 2)
        @loan2 = Factory(:loan, :user => @user, :artefact => @a1, :loan_start => @loan_start, :loan_end => @loan_end, :created_at => Time.now - 1)
        @admin = Factory(:user, :email => "admin@test.com", :administrator => true)
        test_log_in(@admin)
      end
    
      it "should display all the loans, regardless of ordering (DESC)" do
        xhr :get, :reorder, :order => 1
        response.should have_selector("h4", :content => @artefact.name)
        response.should have_selector("h4", :content => @a1.name)
      end
      
      it "should display all the loans, regardless of ordering  (ASC)" do
        xhr :get, :reorder, :order => 2
        response.should have_selector("h4", :content => @artefact.name)
        response.should have_selector("h4", :content => @a1.name)
      end  
    
    end
   
   end
  
end
