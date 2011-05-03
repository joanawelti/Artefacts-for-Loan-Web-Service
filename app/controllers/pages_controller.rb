class PagesController < ApplicationController
    
  def home
    @title = "Artefacts"
    if !logged_in?
      redirect_to login_path
    else
      if current_user.admin?
        @artefacts = Artefact.all
      else 
        # only display artefacts that are visible
        @artefacts = Artefact.where(['visible=? and not user_id=?', true, current_user.id])
      end
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

end
