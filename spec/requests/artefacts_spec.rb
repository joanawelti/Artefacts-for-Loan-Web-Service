require 'spec_helper'

describe "Artefacts" do
  
  before(:each) do
    user = Factory(:user)
    visit login_path
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
  end
  
  describe "GET /artefacts" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get artefacts_path
      response.status.should be(200)
    end
  end
end
