require 'spec_helper'

describe UsersController do
  
  describe "GET trainees" do
    it "doesn't matter" do
      get :trainees
      expect(response.status).to eq(403)
    end
  end

end
