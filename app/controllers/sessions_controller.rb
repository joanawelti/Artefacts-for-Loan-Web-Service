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
      # Sign the user in and redirect to the user's show page.
      log_in user
      redirect_to user
    end
  end
 
  
  def destroy
    log_out
    redirect_to root_path
  end

end
