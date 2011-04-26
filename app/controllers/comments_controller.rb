class CommentsController < ApplicationController
  before_filter :authenticate
  
  before_filter :authorized_user, :only => [:destroy, :edit]

  def create
      @comment  = current_user.comments.build(params[:comment])
      if @comment.save
        flash[:success] = "Comment was created"
        redirect_to reviews_artefact_path(@comment.artefact)
      elsif !params[:comment][:artefact_id].blank?
        @title = "New comment"
        render reviews_artefact_path(Artefact.find(params[:comment][:artefact_id]))  
      else
        @title = "New coment"
        render 'pages/home'
      end
    end

  def destroy
    session[:return_to] = request.referer
    @comment.destroy
    redirect_back_or root_path
  end
  
  def edit
    @title = "Edit comment"
    @comment = Comment.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(review_artefact_path(@comment.artefact), :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
    
    def authorized_user
      @comment = Comment.find(params[:id])
      redirect_to root_path unless current_user?(@comment.user)
    end
end