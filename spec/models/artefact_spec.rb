require 'spec_helper'

describe Artefact do
  
  before(:each) do
    @user = Factory(:user) # every artefact belongs to a user
    @attr = {
      :name => "Test Artifact",
      :description => "Test Artifact to demonstrate functionality of Artefact Model",
      :visible => true,
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
    
     # coordinates
    describe "coordinates" do
      it "should  have a lattitude value that lies in the range [-90,90]" do
        @user.artefacts.build(@attr.merge(:lat => 91)).should_not be_valid
        @user.artefacts.build(@attr.merge(:lat => -91)).should_not be_valid
      end

      it "should  have a longitude value that lies in the range [-180,180]" do
        @user.artefacts.build(@attr.merge(:long=> 181)).should_not be_valid
        @user.artefacts.build(@attr.merge(:lat => -181)).should_not be_valid
      end
      
      it "should only allow numbers as coordinates" do
        @user.artefacts.build(@attr.merge(:lat=> "bd")).should_not be_valid
        @user.artefacts.build(@attr.merge(:long=> "bd")).should_not be_valid
      end
    end
    
  
  end

  describe "loaned artefacts" do
    before(:each) do
      @owner = Factory(:user, :email => Factory.next(:email))
      @artefact = @owner.artefacts.create(@attr)
      @loan_start = get_loan_start_date
      @loan_end = get_loan_end_date(@loan_start)
    end
    
    describe "methods" do

      it "should have a reverse_loan method" do
         @artefact.should respond_to(:reverse_loans)
      end
    
      it "should have a loaned method" do
        @artefact.should respond_to(:loaners)
      end
    
      it "should have a current_loan method" do
        @artefact.should respond_to(:current_loan)
      end    
    
      it "should have an unloan! method" do
        @artefact.should respond_to(:unloan!)
      end
    
      it "should have a loaner? method" do
        @artefact.should respond_to(:loaner?)
      end
      
      it "should have a is_on_loan method" do
        @artefact.should respond_to(:is_on_loan?)
      end
    end  
    
    describe "the current loan" do
      
      it "should include the user in the loaned array" do
        @user.loan!(@artefact, @loan_start, @loan_end)
        @artefact.loaners.should include(@user)
      end
      
      it "should change the availability of the artefact" do
        @user.loan!(@artefact, @loan_start, @loan_end)
        @artefact.is_on_loan?.should be_true
      end
      
      it "should be accessible via the artefact" do
         @user.loan!(@artefact, @loan_start, @loan_end)
         @artefact.current_loan.should == @user.loans.find_by_artefact_id(@artefact.id)
      end
      
      it "should be nil if the artefact is not on loan" do
         @artefact.current_loan.should be_nil
      end
      
      it "should have the correct current loaner" do
        @user.loan!(@artefact, @loan_start, @loan_end)
        @artefact.current_loan.user.should == @user
      end
    end
    
    describe "artefact's location" do
      context "no location set" do
    
        it "should have the user's location assigned when not on loan" do
          u = Factory(:user, :email => Factory.next(:email), :lat => 20.30, :long => 34.556)
          a1 = u.artefacts.create(@attr)
          a1.get_current_location.should == { :lat => u.lat, :long => u.long}
        end
        
        it "should have the borrowers's location assigned when on loan" do
          u = Factory(:user, :email => Factory.next(:email), :lat => 20.30, :long => 34.556)
          u.loan!(@artefact, @loan_start, @loan_end)
          @artefact.get_current_location.should == { :lat => u.lat, :long => u.long}
        end
      end
      
      context "location set" do
        it "should have the artefact's location assigned" do
          a1 = @user.artefacts.create(@attr.merge({ :lat => 20.30, :long => 34.556 }))
          a1.get_current_location.should == { :lat => 20.30, :long => 34.556 }
        end
      end
      
    end
    
    describe "the unloaning process" do
      before(:each) do
        @user.loan!(@artefact, @loan_start, @loan_end)
        @artefact.unloan!
      end
      
      it "should change the availability of the artefact" do
        @artefact.is_on_loan?.should be_false
      end
      
      it "should remember it's previous loaners" do
        @user.loan!(@artefact, @loan_start, @loan_end)
        @artefact.unloan!
        @artefact.loaner?(@user).should be_true
      end
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

    it "should have the right comments in the right order" do
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
