class UsersController < ApplicationController
  def new
    @user = User.new
    @title = "Register"
  end
  
  def show
    @title = "User details"
    @user = User.find(params[:id])
  end
  
  def create
      @user = User.new(params[:user])
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
  
  
end
