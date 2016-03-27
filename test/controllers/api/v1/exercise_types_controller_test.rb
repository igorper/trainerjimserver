require 'test_helper'

class Api::V1::ExerciseTypesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    sign_in FactoryGirl.create(:user)
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

  test "index returns exercise types in JSON" do
    get :index, format: :json
    exercise_types = JSON.parse(response.body).map { |e| e['name'] }
    assert_includes exercise_types, 'Super curl'
  end

  test "index returns not-modified when called with modification date and etag" do
    get :index, format: :json
    copy_response_etag_to_request
    get :index, format: :json
    assert_response :not_modified
  end

  test "index is stale when logging in as different user" do
    get :index, format: :json
    sign_out :user
    sign_in FactoryGirl.create(:user)
    copy_response_etag_to_request
    get :index, format: :json
    assert_response :success
  end

  test "index is stale when changing the language" do
    get :index, format: :json, language: :en
    copy_response_etag_to_request
    get :index, format: :json, language: :sl
    assert_response :success
  end

  test "index is stale when modifying an exercise type" do
    get :index, format: :json
    curl = exercise_types(:curl)
    curl.updated_at = DateTime.now + 3.days
    curl.save
    copy_response_etag_to_request
    get :index, format: :json
    assert_response :success
  end

  test "index is stale when modifying an exercise type translation" do
    get :index, format: :json, language: :sl
    curl = exercise_type_translations(:curl_sl)
    curl.updated_at = DateTime.now + 3.days
    curl.save
    copy_response_etag_to_request
    get :index, format: :json, language: :sl
    assert_response :success
  end

  test "index returns translated exercise types" do
    get :index, format: :json, language: :sl
    exercise_types = JSON.parse(response.body).map { |e| e['name'] }
    assert_includes exercise_types, 'Trebušnjaki'
  end

  test "show returns a translated exercise type" do
    get :show, format: :json, id: exercise_types(:curl).id, language: :sl
    exercise_type = JSON.parse(response.body)
    assert_equal 'Trebušnjaki', exercise_type['name']
  end

  private
  def copy_response_etag_to_request
    @request.headers['If-Modified-Since'] = response['Last-Modified']
    @request.headers['If-None-Match'] = response['ETag']
  end
end
