require 'spec_helper'

describe ForgottenPasswordsController do

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
  end

  describe "POST 'create'" do
    
  end

end
