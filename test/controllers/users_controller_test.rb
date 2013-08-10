require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  include Devise::TestHelpers
  
  test "should succeed when a trainer is signed in" do
    sign_in users(:jim)
    get :trainees
    assert_response :success
  end
  
  test "should fail when nobody is signed in" do
    get :trainees
    assert_response :forbidden
  end
  
  test "should fail when not a trainer" do
    sign_in users(:matej)
    get :trainees
    assert_response :forbidden
  end
  
  test "should return a list of trainees of the trainer" do
    sign_in users(:jim)
    get :trainees, :format => :json
    assert_response :success
    
    trainees = JSON.parse(response.body)
    assert trainees.size == 3
  end

end
