class ArtefactsController < ApplicationController
  
  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy
  
  
  # GET /artefacts
  # GET /artefacts.xml
  def index
    @title = "Artefacts"
    if current_user.admin?
      @artefacts = Artefact.all.paginate(:page => params[:page])
    else 
      # only display artefacts that are visible
      @artefacts = Artefact.where(['visible=? and not user_id=?', true, current_user.id]).paginate(:page => params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artefacts }
    end
  end

  # GET /artefacts/1
  # GET /artefacts/1.xml
  def show
    @artefact = Artefact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @artefact }
    end
  end

  # GET /artefacts/new
  # GET /artefacts/new.xml
  def new
    @title = "New Artefact"
    @artefact = Artefact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @artefact }
    end
  end

  # GET /artefacts/1/edit
  def edit
    @artefact = Artefact.find(params[:id])
  end

  # POST /artefacts
  # POST /artefacts.xml
  def create
    @artefact = current_user.artefacts.build(params[:artefact])
    if @artefact.save
      flash[:success] = "Artefact created successfully"
      redirect_to myartefacts_user_path(current_user)
    else
      @title = "New Artefact"
      render 'new'
    end
  end

  # PUT /artefacts/1
  # PUT /artefacts/1.xml
  def update
    @artefact = Artefact.find(params[:id])

    respond_to do |format|
      if @artefact.update_attributes(params[:artefact])
        format.html { redirect_to(edit_artefact_path(@artefact), :notice => 'Artefact was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @artefact.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @artefact = Artefact.find(params[:id])
    @artefact.destroy      
    flash[:success] = "Artefact deleted successfully"
    redirect_back_or artefacts_path
  end
  
  def reviews
    @title ="Artefact Reviews"
    @artefact = Artefact.find(params[:id])
    @comments = @artefact.comments.paginate(:page => params[:page])
    @comment = Comment.new
  end
  
  def loans
    @title = "Loan History"
    @artefact = Artefact.find(params[:id])
    @loans = @artefact.reverse_loans.paginate(:page => params[:page])
  end


  private
    def authorized_user
        @artefact = Artefact.find(params[:id])
        redirect_to root_path unless current_user?(@artefact.user) or current_user.administrator? 
    end
  
end
