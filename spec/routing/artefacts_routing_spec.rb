require "spec_helper"

describe ArtefactsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/artefacts" }.should route_to(:controller => "artefacts", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/artefacts/new" }.should route_to(:controller => "artefacts", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/artefacts/1" }.should route_to(:controller => "artefacts", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/artefacts/1/edit" }.should route_to(:controller => "artefacts", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/artefacts" }.should route_to(:controller => "artefacts", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/artefacts/1" }.should route_to(:controller => "artefacts", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/artefacts/1" }.should route_to(:controller => "artefacts", :action => "destroy", :id => "1")
    end

  end
end
