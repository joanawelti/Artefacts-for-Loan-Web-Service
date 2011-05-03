require 'pony'

class ForgottenPasswordsController < ApplicationController
  
  def new
    @title = "Forgotten password"
  end

  def create
    @email = params[:forgotten_password][:email]
    @user = User.find_by_email(@email)
    if @user.nil?
        flash[:error] = "There is no user with this email address"
        @title = "Forgotten password"
        render 'new'
      else 
        @new_password = create_password
        @user.update_attributes(:password => @new_password)
        mail_password_to_user(@new_password, @email)
        flash[:success] = "New password was sent to " + @email
        redirect_to login_path
      end
  end


  private
  
    def create_password
      SecureRandom.base64(5)
    end
    
    def mail_password_to_user(password, receiver)
      Pony.mail(:to => receiver, 
                :from => 'me@example.com', 
                :subject => 'New password for the Artefacts Loan Web Service',
                :html_body => 'Your new password is <b>#{password}</b>', 
                :body => "Your new password is #{password}",
                :via => :sendmail)
    end

end
