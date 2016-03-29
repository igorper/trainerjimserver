require 'test_helper'

class Api::V1::MeasurementsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    joe = users(:joe)
    joe.confirmed_at = Date.today
    joe.save
    sign_in joe
  end

  test "index returns unauthorized when not signed in" do
    sign_out(:user)
    get :index, format: :json
    assert_response :unauthorized
  end

  test "index returns success when signed in" do
    get :index, format: :json
    assert_response :success
  end

  test "show returns not found for unknown IDs" do
    get :show, format: :json, id: -1
    assert_response :not_found
  end

  test "show returns a translated exercise type" do
    get :show, format: :json, id: measurements(:curl_measurement).id, language: :sl
    measurement = JSON.parse(response.body)
    assert_equal exercise_type_translations(:curl_sl).name,
                 measurement['training']['exercises'][0]['exercise_type']['name']
  end

  test "getting detailed measurements returns success" do
    get :detailed_measurements, format: :json, language: :sl
    assert_response :success
  end

  test "returns a translated exercise types in detailed measurements" do
    get :detailed_user_measurements, format: :json, user_id: users(:joe).id, language: :sl
    measurement = JSON.parse(response.body)
    assert_equal exercise_type_translations(:curl_sl).name,
                 measurement[0]['training']['exercises'][0]['exercise_type']['name']
  end
end
