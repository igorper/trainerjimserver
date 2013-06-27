require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "admin trainer roles" do
    assert users(:matej).role? :administrator
    assert !(users(:matej).role? :trainer)
    assert users(:jim).role?(:trainer)
    assert !(users(:jim).role? :administrator)
    assert users(:igor).role?(:administrator)
    assert users(:igor).role?(:trainer)
    assert !(users(:joe).role? :trainer)
    assert !(users(:joe).role? :administrator)
  end
end
