require 'spec_helper'

describe UsersController do
  
  describe "GET trainees" do
    context "when not logged in" do
      it { 
        get :trainees
        expect(response.status).to eq(403)
      }
    end
  end
  
end
