require 'test_helper'

class TrainingControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should redirect to the welcome screen if user not logged in" do
    get :workouts
    assert_response :redirect
    assert_equal(welcome_url, @response.location)
  end
  include Devise::TestHelpers

  test "should open up the workouts page when user logged in" do
    sign_in users(:matej)
    get :workouts
    assert_response :success
  end
  
  test "should list all global workout plans" do
    get :templates, :format => :json
    assert_response :success
    returnedWorkouts = JSON.parse(@response.body)
    expectedWorkouts = [trainings(:template1), trainings(:template2)]
    
    assert_equal(returnedWorkouts.size, expectedWorkouts.size)
    
    returnedIds = returnedWorkouts.map { |w| w['id'] }
    expectedIds = expectedWorkouts.map { |w| w.id }
    
    assert_equal(returnedIds.sort, expectedIds.sort)
  end
  
  test "should forbid non-logged-in users access to personal workouts" do
    get :my_templates, :format => :json
    assert_response :forbidden
  end
  
  test "should forbid non-logged-in users access to a specific workout" do
    get :my_template, :format => :json
    assert_response :forbidden
  end
  
  test "should list personal workouts for logged-in users" do
    sign_in users(:matej)
    get :my_templates, :format => :json
    
    assert_response :success
    
    returnedWorkouts = JSON.parse(@response.body)
    expectedWorkouts = [trainings(:matej1), trainings(:matej2)]
    
    assert_equal(returnedWorkouts.size, expectedWorkouts.size)
    
    returnedIds = returnedWorkouts.map { |w| w['id'] }
    expectedIds = expectedWorkouts.map { |w| w.id }
    
    assert_equal(returnedIds.sort, expectedIds.sort)
  end
  
  test "forbid logged-in users' access to workouts of other people" do
    sign_in users(:matej)
    get :my_template, :format => :json, :id => trainings(:igor1)
    
    assert_response :forbidden
  end
  
  test "return the workout of the logged-in users" do
    sign_in users(:matej)
    get :my_template, :format => :json, :id => trainings(:matej1)
    
    assert_response :success
    
    returnedWorkout = JSON.parse(@response.body)
    
    assert_equal(returnedWorkout['id'], trainings(:matej1).id)
    assert_equal(returnedWorkout['name'], trainings(:matej1).name)
  end
end
