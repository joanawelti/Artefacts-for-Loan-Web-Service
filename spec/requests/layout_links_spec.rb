require 'spec_helper'

describe "LayoutLinks" do

  describe "Application" do
    pending "should have a Home page at '/'" do
      get '/'
      response.should have_selector('title', :content => "")
    end

    pending "should have a Contact page at '/contact'" do
      get '/contact'
      response.should have_selector('title', :content => "Contact")
    end

    pending "should have an About page at '/about'" do
      get '/about'
      response.should have_selector('title', :content => "About")
    end

    pending "should have a Help page at '/help'" do
      get '/help'
      response.should have_selector('title', :content => "Help")
    end
  end
  
  describe "when not signed in" do
      it "should have a signin link" do
        visit root_path
        response.should have_selector("a", :href => login_path,
                                           :content => "Log in")
      end
    end

    describe "when signed in" do

      before(:each) do
        @user = Factory(:user)
        visit login_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
      end

      it "should have a signout link" do
        visit root_path
        response.should have_selector("a", :href => logout_path,
                                           :content => "Log out")
      end
      
      it "should have a link to the user's data" do
          visit root_path
          response.should have_selector("a", :href => user_path(@user),
                                               :content => "My details" )
      end
      
      it "should have a link to the user's artefacts" do
          visit root_path
          response.should have_selector("a", :href => myartefacts_user_path(@user),
                                              :content => "My artefacts" )
      end
      
      it "should have a link to the user's loans" do
          visit root_path
          response.should have_selector("a", :href => myloans_user_path(@user),
                                              :content => "My loans" )
      end
      
      it "should have a link to the user's loaned artefacts" do
          visit root_path
          response.should have_selector("a", :href => myloanedartefacts_user_path(@user),
                                              :content => "My loaned artefacts" )
      end
      

    end
  
  
end
