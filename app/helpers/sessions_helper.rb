module SessionsHelper
  
  ##
  # Log in user
  #
  def log_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  ##
  # Assign user to current_user
  #
  def current_user=(user)
    @current_user = user
  end 
  
  ##
  # Returns current user
  #
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  ##
  # Returns true if the user is logged in 
  #
  def logged_in?
    !current_user.nil?
  end
  
  ##
  # Ends session and loggs out the user
  #
  def log_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  ##
  # Redirects to the loggin page if the user is not logged in 
  #
  def authenticate
    deny_access unless logged_in?
  end

  ##
  # Redirects to the main page if the current user is not an administrator
  #
  def authenticate_admin
    redirect_to(root_path) unless current_user.administrator?
  end

  ##
  # Checks if the user in the request is identical to the current user
  # Admins are always correct users 
  #
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user) or current_user.administrator?
  end
  
  ##
  # Redirects to the loggin page, store location
  #
  def deny_access
    store_location
    redirect_to login_path, :notice => "You must be logged in in order to access this page."
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  ##
  # Returns true if user is the current_user
  #
  def current_user?(user)
    user == current_user
  end
   
  
  private
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
    def store_location
      session[:return_to] = request.fullpath
    end
    
    def clear_return_to
      session[:return_to] =  nil
    end

end
