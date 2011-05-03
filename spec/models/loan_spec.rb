require 'spec_helper'

describe Loan do

  before(:each) do
    @user = Factory(:user)
    @owner = Factory(:user, :email => Factory.next(:email))
    @artefact = Factory(:artefact, :user => @owner)
    @loan_start = get_loan_start_date
    @loan_end = get_loan_end_date(@loan_start)
    @attr = { :artefact_id => @artefact.id, :loan_start => @loan_start, :loan_end => @loan_end }
    @loan = @user.loans.build(@attr)
  end

  it "should create a new loan given valid attributes" do
    @loan.save!
  end
  
  describe "loan methods" do
    
    before(:each) do
      @loan.save
    end

    it "should have a loaner attribute" do
      @loan.should respond_to(:user)
    end

    it "should have the right loaner" do
      @loan.user.should == @user
    end

    it "should have a loaned attribute" do
      @loan.should respond_to(:artefact)
    end

    it "should have the right followed user" do
      @loan.artefact.should == @artefact
    end
    
  end
  
  describe "validations" do

    it "should require a user id" do
      @loan.user_id = nil
      @loan.should_not be_valid
    end

    it "should require an artefact id" do
      @loan.artefact_id = nil
      @loan.should_not be_valid
    end 
    
    describe "loan dates" do
      it "should require a start date" do
        @loan.loan_start = nil
        @loan.should_not be_valid
      end
      
      it "should require an end date" do
        @loan.loan_end = nil
        @loan.should_not be_valid
      end
      
      it "should have an end date that is not before the start date" do
        @loan.loan_end.should > @loan.loan_start
      end
      
      it "should have start date that is not in the futre" do
        @loan.loan_start.should <= Date.current
      end
      
      it "should be for at most a month" do
        (@loan.loan_end - @loan.loan_start).to_i.should <= 31
      end
    end
  end
  
end
