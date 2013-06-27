require 'test_helper'

class Utils::AssetsControllerTest < ActionController::TestCase
  
  test "An existing asset path should be returned" do
    post(:asset, name: 'workouts/Treningi_template_1.png')
    
    assert_response :redirect 
    assert_equal('http://test.host/assets/workouts/Treningi_template_1.png', @response.location)
  end
  
end
