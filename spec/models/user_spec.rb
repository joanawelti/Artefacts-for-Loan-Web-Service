# Some testcases taken from the "Ruby on Rails Tutorial by Michael Hartl" [http://ruby.railstutorial.org]
#
# author: Joana Welti (joana.welti.10@aberdeen.ac.uk)
# date: 15/03/2011

require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :firstname => "Example", :lastname => "User", :email => "user@example.com", :address => "Examplestreet 24", :city => "Aberdeen", :postcode => "1WU 24AB", :country => "UK", :mobile => "077 574 27217"}
  end

# creation
  it "should create a new user with example attributes" do
    User.create!(@attr)
  end
  
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
  
  # Email
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
    
  
  # Address
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

