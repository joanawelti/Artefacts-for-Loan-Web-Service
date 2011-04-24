require 'spec_helper'

describe Comment do
  
  before(:each) do
    @user = Factory(:user)
    @owner = Factory(:user, :email => Factory.next(:email))
    @artefact = Factory(:artefact, :user => @owner)
    @attr = { :content => "value for content", :artefact_id => @artefact.id }
  end

  it "should create a new instance given valid attributes" do
    @user.comments.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @comment = @user.comments.create(@attr)
    end

    it "should have a user attribute" do
      @comment.should respond_to(:user)
    end

    it "should have the right associated user" do
      @comment.user_id.should == @user.id
      @comment.user.should == @user
    end
  end
  
  describe "artefact associations" do

    before(:each) do
      @comment = @user.comments.create(@attr)    
    end

    it "should have an artefact attribute" do
      @comment.should respond_to(:artefact)
    end

    it "should have the right associated artefact" do
      @comment.artefact_id.should == @artefact.id
      @comment.artefact.should == @artefact
    end
  end
  
  describe "validations" do

    it "should require a user id" do
      Comment.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.comments.build(:content => "  ").should_not be_valid
    end

    it "should reject long content" do
      @user.comments.build(:content => "a" * 501).should_not be_valid
    end
  end
  
end
