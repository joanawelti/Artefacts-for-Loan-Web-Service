require 'spec_helper'

describe "LayoutLinks" do
  
  describe "Application" do
  
    context "when not signed in" do
      
      it "should have a Login page at '/login'" do
        get '/login'
        response.should have_selector('title', :content => "Log in")
      end
      
      it "should have a signin link" do
        visit root_path
        response.should have_selector("a", :href => login_path,
                                           :content => "Log in")
      end
    end

    context "when signed in" do

      before(:each) do
        @user = Factory(:user)
        visit login_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
      end
      
      describe "static pages" do
        it "should have a Home page at '/'" do
          get '/'
          response.should have_selector('title', :content => "Artefacts")
        end

        it "should have a Contact page at '/contact'" do
          get '/contact'
          response.should have_selector('title', :content => "Contact")
        end

        it "should have an About page at '/about'" do
          get '/about'
          response.should have_selector('title', :content => "About")
        end

      end
      
      describe "Navigation" do

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
      end

    end
    
    context "as an admin" do
      before(:each) do
        @user = Factory(:user, :administrator => true)
        visit login_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
      end

      it "should have a link to all loans" do
        visit root_path
        response.should have_selector("a", :href => loans_path,
                                            :content => "All loans" )
      end
      
      it "should have a link to all users" do
        visit root_path
        response.should have_selector("a", :href => users_path,
                                            :content => "All users" )
      end
    end
    
  end
  
  
end
