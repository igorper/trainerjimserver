# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  full_name              :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  trainer_id             :integer
#

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
