class ArtefactsController < ApplicationController
  # GET /artefacts
  # GET /artefacts.xml
  def index
    @artefacts = Artefact.all

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
    @artefact = Artefact.new(params[:artefact])

    respond_to do |format|
      if @artefact.save
        format.html { redirect_to(@artefact, :notice => 'Artefact was successfully created.') }
        format.xml  { render :xml => @artefact, :status => :created, :location => @artefact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @artefact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /artefacts/1
  # PUT /artefacts/1.xml
  def update
    @artefact = Artefact.find(params[:id])

    respond_to do |format|
      if @artefact.update_attributes(params[:artefact])
        format.html { redirect_to(@artefact, :notice => 'Artefact was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @artefact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /artefacts/1
  # DELETE /artefacts/1.xml
  def destroy
    @artefact = Artefact.find(params[:id])
    @artefact.destroy

    respond_to do |format|
      format.html { redirect_to(artefacts_url) }
      format.xml  { head :ok }
    end
  end
end
