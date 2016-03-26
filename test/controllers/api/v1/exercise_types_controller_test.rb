require 'test_helper'

class Api::V1::ExerciseTypesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  test "index returns unauthorized when not signed in" do
    get :index, format: :json
    assert_response :unauthorized
  end

  test "index returns success when signed in" do
    do_sign_in
    get :index, format: :json
    assert_response :success
  end

  test "index returns exercise types in JSON" do
    do_sign_in
    get :index, format: :json
    exercise_types = JSON.parse(response.body).map { |e| e['name'] }
    assert_includes exercise_types, 'Super curl'
  end

  test "index returns translated exercise types" do
    do_sign_in
    get :index, format: :json, language: :sl
    exercise_types = JSON.parse(response.body).map { |e| e['name'] }
    assert_includes exercise_types, 'Trebušnjaki'
  end

  test "show returns a translated exercise type" do
    do_sign_in
    get :show, format: :json, id: exercise_types(:curl).id.to_s, language: :sl
    exercise_type = JSON.parse(response.body)
    assert_equal 'Trebušnjaki', exercise_type['name']
  end

  def do_sign_in
    sign_in FactoryGirl.create(:user)
  end
end
