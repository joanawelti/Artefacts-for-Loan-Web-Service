require 'spec_helper'

describe "Users" do
  describe "GET /users" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get users_path
      response.status.should be(200)
    end
  end
  
  describe "log in/out" do

      describe "failure" do
        it "should not log a user in" do
          visit login_path
          fill_in :email,    :with => ""
          fill_in :password, :with => ""
          click_button
          response.should have_selector("div.flash.error", :content => "isn't correct")
        end
      end

      describe "success" do
        it "should log a user in and out" do
          user = Factory(:user)
          visit login_path
          fill_in :email,    :with => user.email
          fill_in :password, :with => user.password
          click_button
          controller.should be_logged_in
          click_link "Log out"
          controller.should_not be_logged_in
        end
      end
      
    end
  
  
end
