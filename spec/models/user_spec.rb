# Some testcases taken from the "Ruby on Rails Tutorial by Michael Hartl" [http://ruby.railstutorial.org]
#
# author: Joana Welti (joana.welti.10@aberdeen.ac.uk)
# date: 15/03/2011

require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :firstname => "Example", 
              :lastname => "User", 
              :email => "user@example.com", 
              :address => "Examplestreet 24", 
              :city => "Aberdeen", :postcode => "1WU 24AB", 
              :country => "UK", 
              :mobile => "077 574 27217",
              :password => "passwordForExample", 
              :password_confirmation => "passwordForExample",
              :lat => 24.5678,
              :long => 56.789245 }
  end

# creation
  describe "creation" do
    it "should create a new user with example attributes" do
      User.create!(@attr)
    end
    
    # user id
    it "should have a userid attribute" do
      test_user = User.create!(@attr)
      test_user.should respond_to(:userid)
    end
    
  end
  
  describe "name of user" do
    # Name  
    it "should require a first name" do
      no_firstname_user = User.new(@attr.merge(:firstname => ""))
      no_firstname_user.should_not be_valid
    end
  
    it "should require a last name" do
      no_lastname_user = User.new(@attr.merge(:lastname => ""))
      no_lastname_user.should_not be_valid
    end
  
    it "should reject first names that are too long" do
      long_name = "a" * 26
      long_name_user = User.new(@attr.merge(:firstname => long_name))
      long_name_user.should_not be_valid
    end
    
    it "should reject last names that are too long" do
      long_name = "a" * 26
      long_name_user = User.new(@attr.merge(:lastname => long_name))
      long_name_user.should_not be_valid
    end
  end
  
  # Email
  describe "email for user" do
    it "should require an email address" do
        no_email_user = User.new(@attr.merge(:email => ""))
        no_email_user.should_not be_valid
    end
  
    it "should accept valid email addresses" do
        addresses = %w[example_user@abdn.ac.uk EXAMPLE.USER@test.com user-Test@foo.uk]
        addresses.each do |address|
          valid_email_user = User.new(@attr.merge(:email => address))
          valid_email_user.should be_valid
        end
      end

      it "should reject invalid email addresses" do
        addresses = %w[wrong.com !test@test. no@]
        addresses.each do |address|
          invalid_email_user = User.new(@attr.merge(:email => address))
          invalid_email_user.should_not be_valid
        end
      end
    
    
      it "should reject duplicate email addresses" do
        User.create!(@attr)
        user_two = User.new(@attr)
        user_two.should_not be_valid
      end
    
      it "should reject email addresses identical up to case" do
          upcased_email = @attr[:email].upcase
          User.create!(@attr.merge(:email => upcased_email))
          user_with_duplicate_email = User.new(@attr)
          user_with_duplicate_email.should_not be_valid
      end
    end
    
  
  # Address
  describe "users address" do
    it "should require an address" do
        no_address_user = User.new(@attr.merge(:address => ""))
        no_address_user.should_not be_valid
    end
  
    it "should require a city" do
        no_city_user = User.new(@attr.merge(:city => ""))
        no_city_user.should_not be_valid
    end
  
    it "should require a postcode" do
        no_postcode_user = User.new(@attr.merge(:postcode => ""))
        no_postcode_user.should_not be_valid
    end
  
    it "should require a country" do
        no_country_user = User.new(@attr.merge(:country => ""))
        no_country_user.should_not be_valid
    end
  end
  
   # coordinates
  describe "coordinates" do
    it "should  have a lattitude value that lies in the range [-90,90]" do
      wrong_lat_user = User.new(@attr.merge(:lat => 91))
      wrong_lat_user.should_not be_valid
      
      wrong_lat_user = User.new(@attr.merge(:lat => -91))
      wrong_lat_user.should_not be_valid
    end
      
    it "should  have a longitude value that lies in the range [-180,180]" do
      wrong_long_user = User.new(@attr.merge(:long => 181.0))
      wrong_long_user.should_not be_valid
      
      wrong_long_user = User.new(@attr.merge(:long => -181.0))
      wrong_long_user.should_not be_valid
    end
  end
  
  # Administrator
  describe "admin attribute" do

      before(:each) do
        @user = User.create!(@attr)
      end

      it "should respond to admin" do
        @user.should respond_to(:administrator)
      end

      it "should not be an admin by default" do
        @user.should_not be_admin
      end

      it "should be convertible to an admin" do
        @user.toggle!(:administrator)
        @user.should be_admin
      end
    end
  
  # Password
  describe "authentication" do
    describe "password creation" do
      it "should require a password" do
          no_password_user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
          no_password_user.should_not be_valid
      end

      it "should require a password confirmation that matches the password" do
          wrong_confirmation_user = User.new(@attr.merge(:password_confirmation => "invalid"))
          wrong_confirmation_user.should_not be_valid
      end

      it "should reject passwords that are shorter than 6 chars" do
          short = "x" * 5
          hash = @attr.merge(:password => short, :password_confirmation => short)
          User.new(hash).should_not be_valid
       end

       it "should reject passwords longer than 20 chars" do
          long = "x" * 21
          hash = @attr.merge(:password => long, :password_confirmation => long)
          User.new(hash).should_not be_valid
        end
    end
    
    describe "password encryption" do
        before(:each) do
          @user = User.create!(@attr)
        end

        it "should have an encrypted password attribute" do
          @user.should respond_to(:encrypted_password)
        end
        
        it "should set the encrypted password" do
            @user.encrypted_password.should_not be_blank
        end 
        describe "has_password? method" do
          it "should be true if the passwords match" do
              @user.has_password?(@attr[:password]).should be_true
            end    

            it "should be false if the passwords don't match" do
              @user.has_password?("invalid").should be_false
            end 
        end
        
        describe "authenticate method" do
          it "should return nil on email/password mismatch" do
              wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
              wrong_password_user.should be_nil
          end

          it "should return nil for an email address with no user" do
              nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
              nonexistent_user.should be_nil
          end

          it "should return the user on email/password match" do
              matching_user = User.authenticate(@attr[:email], @attr[:password])
              matching_user.should == @user
          end
        end
      end
  end
  
  describe "artefacts associations" do
    
    before(:each) do
      @user = User.create(@attr)
      #test_log_in(@user)
      @art1 = Factory(:artefact, :name => "Kkk", :user => @user)
      @art2 = Factory(:artefact, :name => "Zzz", :user => @user)
      @art3 = Factory(:artefact, :name => "Aaa", :user => @user)
    end
    
    it "should have an artefact attriubte" do
      @user.should respond_to(:artefacts)
    end
    
    it "should have the right artefacts, ordered alphabetically" do
      @user.artefacts.should == [@art3, @art1, @art2]
    end
    
    it "should not include a different user's artefacts" do
      art4 = Factory(:artefact, :name => "XYZ",
                                :user => Factory(:user, :email => Factory.next(:email)))
      @user.artefacts.include?(art4).should be_false
    end
    
    it "should destroy the associated artefacts when the user is deleted" do
      @user.destroy
      [@art1, @art2, @art3].each do |artefact|
       
        lambda do
          Artefact.find(artefact.id)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
  end
      
  describe "loans" do

    before(:each) do
      @user = User.create!(@attr)
      @owner = Factory(:user, :email => Factory.next(:email))
      @artefact = Factory(:artefact, :user => @owner)
      @loan_start = get_loan_start_date
      @loan_end = get_loan_end_date(@loan_start)
    end

    it "should have a loan method" do
      @user.should respond_to(:loans)
    end
    
    it "should have a loaned method" do
      @user.should respond_to(:loaned_items)
    end
    
    it "should have a loaned? method" do
      @user.should respond_to(:loaned?)
    end

    it "should have a loan! method" do
      @user.should respond_to(:loan!)
    end

    describe "the loaning process" do
      before(:each) do
        @user.loan!(@artefact, @loan_start, @loan_end)
      end
      
      it "should loan an artefact" do    
        @user.should be_loaned(@artefact)
      end

      it "should include the followed user in the loaned array" do
        @user.loaned_items.should include(@artefact)
      end
      
      it "should have the right loans in the right order" do
        artefact2 = Factory(:artefact, :user => @owner, :name => "BBB")
        @user.loan!(artefact2, @loan_start, @loan_end)
        @user.loans.first.artefact_id.should == artefact2.id
        @user.loans.second.artefact_id.should == @artefact.id
      end
      
      it "should not be possible for the owner to loan his/her own artefacts" do
        artefact2 = Factory(:artefact, :user => @user, :name => "BBB")
        @user.loan!(artefact2, @loan_start, @loan_end)
        @user.loaned?(artefact2).should be_false
      end
      
      it "should only allow one loaner at a time" do
        other_user = Factory(:user, :email => Factory.next(:email))
        @user.loan!(@artefact, @loan_start, @loan_end)
        other_user.loan!(@artefact, @loan_start, @loan_end)
        other_user.loaned?(@artefact).should be_false
      end
      
    end
    
    describe "the unloaning process" do
      before(:each) do
        @user.loan!(@artefact, @loan_start, @loan_end)
        @artefact.unloan!
      end
      
      it "should unloan an artefact" do
        @user.loaned?(@artefact).should be_false
      end
    end
  
  
  end
  
  describe "comments associations" do

    before(:each) do
      @user = User.create(@attr)
      @owner = Factory(:user, :email => Factory.next(:email))
      @artefact = Factory(:artefact, :user => @owner)
      
      @c1 = Factory(:comment, :user => @user, :artefact_id => @artefact.id, :created_at => 1.day.ago)
      @c2 = Factory(:comment, :user => @user, :artefact_id => @artefact.id, :created_at => 1.hour.ago)
    end

    it "should have a comment attribute" do
      @user.should respond_to(:comments)
    end
    
    it "should destroy associated comments" do
      @user.destroy
      [@c1, @c2].each do |comment|
        Comment.find_by_id(comment.id).should be_nil
      end
    end
  
  end
  
end

