class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:edit, :update, :destroy, :index, :myartefacts, :myloans, :loanedartefacts] #methods only for logged in users
  before_filter :correct_user, :only => [:edit, :update]  
  before_filter :authenticate_admin, :only => [:index, :destroy]
  
  
  def index
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end
  
  def new
    @user = User.new
    @title = "Register"
  end
  
  def show
    redirect_to edit_user_path
  end
  
  def create
    @user = User.new(params[:user])
    puts "s"
    puts Gmaps4rails.geocode(@user.address)
    puts "t"
    if @user.save
      # Handle a successful save.
      log_in @user
      flash[:success] = "Registration was successful"
      redirect_to @user
    else
      @title = "Register"
      render 'new'
    end
  end
    
  def edit
    @title = "User details"
  end
  
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash.now[:success] = "Account updated successfully"
    end
    @title = "User details"
    render 'edit'
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted successfully"
    redirect_to users_path
  end
  
  def myartefacts
    @title = "My artefacts"
    @user = User.find(params[:id])
    @artefacts = @user.artefacts.paginate(:page => params[:page])
  end
  
  def myloans
    @title = "My loans"
    @user = User.find(params[:id])
    @artefacts = @user.loaned_items.paginate(:page => params[:page])
  end
  
end
