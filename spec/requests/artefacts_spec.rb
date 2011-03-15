require 'spec_helper'

describe "Artefacts" do
  describe "GET /artefacts" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get artefacts_path
      response.status.should be(200)
    end
  end
end
