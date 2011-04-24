require 'spec_helper'

describe Loan do

  before(:each) do
    @user = Factory(:user)
    @owner = Factory(:user, :email => Factory.next(:email))
    @artefact = Factory(:artefact, :user => @owner)

    @loan = @user.loans.build(:loaned_id => @artefact.id)
  end

  it "should create a new loan given valid attributes" do
    @loan.save!
  end
  
  describe "loan methods" do
    
    before(:each) do
      @loan.save
    end

    it "should have a loaner attribute" do
      @loan.should respond_to(:loaner)
    end

    it "should have the right loaner" do
      @loan.loaner.should == @user
    end

    it "should have a loaned attribute" do
      @loan.should respond_to(:loaned)
    end

    it "should have the right followed user" do
      @loan.loaned.should == @artefact
    end
  end
  
  describe "validations" do

    it "should require a loaner_id" do
      @loan.loaner_id = nil
      @loan.should_not be_valid
    end

    it "should require a loaned_id" do
      @loan.loaned_id = nil
      @loan.should_not be_valid
    end
  end
  
end
