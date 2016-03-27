require 'test_helper'

class Api::V1::TrainingsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    joe = users(:joe)
    joe.confirmed_at = Date.today
    joe.save
    sign_in joe
  end

  test "index returns unauthorized when not signed in" do
    sign_out(:user)
    get :show, format: :json, id: trainings(:curl_training).id
    assert_response :unauthorized
  end

  test "show returns a translated exercise type" do
    get :show, format: :json, id: trainings(:curl_training).id, language: :sl
    training = JSON.parse(response.body)
    assert_equal exercise_type_translations(:curl_sl).name,
                 training['exercises'][0]['exercise_type']['name']
  end
end
