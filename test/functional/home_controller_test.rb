require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "The welcome screen should be displayed" do
    get :welcome
    assert_response :success
  end

end
