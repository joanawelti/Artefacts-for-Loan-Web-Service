class SessionsController < ApplicationController
  def new
    @title = "Log in"
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      # Create an error message and re-render the signin form.
      flash.now[:error] = "The user name or password you entered isn't correct. Try entering it again."
      @title = "Log in"
      render :new
    else
      log_in user
      redirect_back_or user
    end
  end
 
  
  def destroy
    log_out
    redirect_to login_path
  end

end
