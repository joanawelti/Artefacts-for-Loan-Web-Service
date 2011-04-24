require 'spec_helper'

describe Artefact do
  
  before(:each) do
    @user = Factory(:user) # every artefact belongs to a user
    @attr = {
      :name => "Test Artifact",
      :description => "Test Artifact to demonstrate functionality of Artefact Model"
    }
  end
  
  describe "creation" do
    it "should create a new artifact with example attributes" do
      @user.artefacts.create!(@attr)
    end
  end
  
  describe "user associations" do
    
    before(:each) do
      @artefact = @user.artefacts.create(@attr)
    end
    
    it "should have a user attribute" do
      @artefact.should respond_to(:user)
    end
    
    it "should have the right user associated to it" do
      @artefact.user_id.should == @user.id
      @artefact.user.should == @user
    end
  
  end


  describe "validation" do
    it "should require an association to a user" do
      Artefact.new(@attr).should_not be_valid
    end
  
    it "should require a non-blank name" do
      @user.artefacts.build(:name => "").should_not be_valid
    end
    
    it "should reject names that are too long" do
      @user.artefacts.build(@attr.merge(:name => 'a'*201)).should_not be_valid
    end
  
  end

  describe "loans" do
    before(:each) do
      @owner = Factory(:user, :email => Factory.next(:email))
      @artefact = @owner.artefacts.create(@attr)
    end

    it "should have a reverse_loan method" do
       @artefact.should respond_to(:reverse_loans)
    end
    
    it "should have a loaned method" do
      @artefact.should respond_to(:loaners)
    end
    
    it "should have a loaned? method" do
      @artefact.should respond_to(:loaner?)
    end    
  

    it "should include the user in the loaned array" do
        @user.loan!(@artefact)
        @artefact.loaners.should include(@user)
    end
  
  end
  
  describe "comments associations" do

    before(:each) do
      @owner = Factory(:user, :email => Factory.next(:email))
      @artefact = @owner.artefacts.create(@attr)
      
      @c1 = Factory(:comment, :user => @user, :artefact => @artefact, :created_at => 1.day.ago)
      @c2 = Factory(:comment, :user => @user, :artefact => @artefact, :created_at => 1.hour.ago)
    end

    it "should have a comment attribute" do
      @artefact.should respond_to(:comments)
    end

    it "should have the right microposts in the right order" do
      @artefact.comments.should == [@c2, @c1]
    end
    
    it "should destroy associated comments" do
      @artefact.destroy
      [@c1, @c2].each do |comment|
        Comment.find_by_id(comment.id).should be_nil
      end
    end
  
  end


end
