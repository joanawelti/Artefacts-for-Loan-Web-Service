require 'spec_helper'

describe UsersController do
  render_views
  
  describe "Get 'index'" do
    
    describe "for non-logged-in users" do
         it "should deny access" do
           get :index
           response.should redirect_to(login_path)
           flash[:notice].should =~ /logged in/i
         end
       end

       describe "for logged-in non-admin users" do
         
         before(:each) do
           @user = Factory(:user)
           test_log_in(@user)
         end
         
         it "should redirect to the root page" do
           get :index
          response.should redirect_to(root_path)
        end 
        
       end
       
       describe "for logged-in admin users" do

          before(:each) do
            @admin = Factory(:user, :firstname => "Admin", :email => "admin@example.com")
            @admin.toggle!(:administrator)
            test_log_in(@admin)
            
            regular_user1 = Factory(:user, :firstname => "Robert", :email => "robert@example.com")
            regular_user2 = Factory(:user, :firstname => "Sarah", :email => "sarah@example.net")
            
            @users = [@admin, regular_user1, regular_user2]
            30.times do
              @users << Factory(:user, :email => Factory.next(:email))
            end
            
          end

          it "should be successful" do
            get :index
            response.should be_success
          end
          
          it "should have the right title" do
            get :index
            response.should have_selector("title", :content => "All users")
          end
          
           it "should have an element for each user" do
            get :index
            @users[0..2].each do |user|
                response.should have_selector("li", :content => user.firstname + " " + user.lastname)
            end
          end
            
          it "should paginate users" do
            get :index
            response.should have_selector("div.pagination")
            response.should have_selector("span.disabled", :content => "Previous")
            response.should have_selector("a", :href => "/users?page=2",
                                               :content => "2")
            response.should have_selector("a", :href => "/users?page=2",
                                               :content => "Next")
          end
      end
    
  end

  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end
  end
  
  
  describe "GET 'edit'" do
    
    before(:each) do
      @user = Factory(:user)
      test_log_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :edit, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "User details")
    end

    
    
    #it "should have the right title" do
    #  get :show, :id => @user
    #  response.should have_selector("title", :content => @user.name)
    #end
  end
  
  
  describe "POST 'create'" do
    describe "failure" do

        before(:each) do
          @attr = { :firstname => "", 
                    :lastname => "", 
                    :email => "", 
                    :address => "", 
                    :city => "", 
                    :postcode => "", 
                    :country => "", 
                    :mobile => "",
                    :password => "", 
                    :password_confirmation => "" }
        end

        it "should not create a user" do
          lambda do
            post :create, :user => @attr
          end.should_not change(User, :count)
        end

        it "should have the right title" do
          post :create, :user => @attr
          response.should have_selector("title", :content => "Register")
        end

        it "should render the 'new' page" do
          post :create, :user => @attr
          response.should render_template('new')
        end
  
    end
    
    describe "success" do

          before(:each) do
            @attr = { :firstname => "Example", 
                      :lastname => "User", 
                      :email => "user@example.com", 
                      :address => "Examplestreet 24", 
                      :city => "Aberdeen", :postcode => "1WU 24AB", 
                      :country => "UK", 
                      :mobile => "07757427217",
                      :password => "passwordForExample", 
                      :password_confirmation => "passwordForExample" }
          end

          it "should create a new user" do
            lambda do
              post :create, :user => @attr
            end.should change(User, :count).by(1)
          end

          pending "should redirect to the artifacts on loan page" do
            post :create, :user => @attr
            response.should redirect_to(user_path(assigns(:user)))
          end 
          
          it "should have a welcome message" do
            post :create, :user => @attr
            flash[:success].should =~ /Registration was successful/i
          end
          
          it "should log the user in" do
            post :create, :user => @attr
            controller.should be_logged_in
          end
             
      end
  end
    
  describe "PUT 'update'" do

      before(:each) do
        @user = Factory(:user)
        test_log_in(@user)
      end

      describe "failure" do

        before(:each) do
          @attr = { :firstname => "", 
                    :lastname => "", 
                    :email => "", 
                    :address => "", 
                    :city => "", 
                    :postcode => "", 
                    :country => "", 
                    :mobile => "",
                    :password => "", 
                    :password_confirmation => "" }
        end

        it "should render the 'edit' page" do
          put :update, :id => @user, :user => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => "User details")
        end
      end

      describe "success" do
        before(:each) do
          @attr = { :firstname => "New", 
                    :lastname => "User", 
                    :email => "userNew@example.com", 
                    :address => "Examplestreet 24", 
                    :city => "Aberdeen", :postcode => "1WU 24AB", 
                    :country => "UK", 
                    :mobile => "07757427217",
                    :password => "passwordForExample", 
                    :password_confirmation => "passwordForExample" }
        end
        

        it "should change the user's attributes" do
          put :update, :id => @user, :user => @attr
          @user.reload
          @user.firstname.should  == @attr[:firstname]
          @user.email.should == @attr[:email]
        end

        it "should display the edit page" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => "User details")
        end

        it "should have a flash message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated successfully/
        end
        
      end
        
  end
  
  describe "authentication of edit/update pages" do

      before(:each) do
        @user = Factory(:user)
      end

      describe "for non-signed-in users" do

        it "should deny access to 'edit'" do
          get :edit, :id => @user
          response.should redirect_to(login_path)
        end

        it "should deny access to 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(login_path)
        end
      end
      
      describe "for signed-in non-admin users" do

        before(:each) do
          wrong_user = Factory(:user, :email => "john2@example.com")
          test_log_in(wrong_user)
        end

        it "should require matching users for 'edit'" do
          get :edit, :id => @user
          response.should redirect_to(root_path)
        end

        it "should require matching users for 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(root_path)
        end
      end
      
      describe "for signed-in admin users" do

        before(:each) do
          admin = Factory(:user, :email => "admin@test.com", :administrator => true)
          test_log_in(admin)
        end

        it "should allow 'edit' for any user" do
          get :edit, :id => @user
          response.should_not redirect_to(root_path)
        end

        it "should allow 'update' for any user" do
          put :update, :id => @user, :user => { :firstname => "Pascal" }
          response.should_not redirect_to(root_path)
        end
      end
      
    end
    
    describe "DELETE 'destroy'" do

        before(:each) do
          @user = Factory(:user)
        end

        describe "as a non-signed-in user" do
          it "should deny access" do
            delete :destroy, :id => @user
            response.should redirect_to(login_path)
          end
        end

        describe "as a non-admin user" do
          it "should protect the page" do
            test_log_in(@user)
            delete :destroy, :id => @user
            response.should redirect_to(root_path)
          end
        end

        describe "as an admin user" do

          before(:each) do
            admin = Factory(:user, :email => "admin@example.com", :administrator => true)
            test_log_in(admin)
          end

          it "should destroy the user" do
            lambda do
              delete :destroy, :id => @user
            end.should change(User, :count).by(-1)
          end

          it "should redirect to the users page" do
            delete :destroy, :id => @user
            response.should redirect_to(users_path)
          end
        end
      
    end
    
    describe "GET 'myartefacts'" do
      
      describe "as a non-logged-in user" do
        it "should deny access" do
          get :myartefacts, :id => 1
          response.should redirect_to(login_path)
        end
      end

      describe "as a logged-in user" do
        
        before(:each) do
            @user = Factory(:user)
            test_log_in(@user)
        end

        it "should have the right title" do
          get :myartefacts, :id => @user
          response.should have_selector("title", :content => "My artefacts")
        end
      end
    end
    
    describe "loan pages" do

        describe "when not logged in" do

          it "should protect 'myloans'" do
            get :myloans, :id => 1
            response.should redirect_to(login_path)
          end
        end

        describe "when logged in" do

          before(:each) do 
            @user = Factory(:user)
            test_log_in(@user)
            @owner = Factory(:user, :email => Factory.next(:email))
            @artefact1 = Factory(:artefact, :name => "AAA", :user => @owner)
            @artefact2 = Factory(:artefact, :name => "BBB", :user => @user)
            @loan_start = get_loan_start_date
            @loan_end = get_loan_end_date(@loan_start)
            @user.loan!(@artefact1, @loan_start, @loan_end)
            @owner.loan!(@artefact2, @loan_start, @loan_end)
          end

          it "should show loaned artefacts" do
            get :myloans, :id => @user
            response.should have_selector("a", :href => artefact_path(@artefact1))
          end

          pending "should show user followers" do
            get :myloanedartefacts, :id => @user
            response.should have_selector("a", :href => artefact_path(@artefact2))
          end
        end
      end

end    

