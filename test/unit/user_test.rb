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
    assert users(:matej).is_administrator
    assert !(users(:matej).is_trainer)
    assert users(:jim).is_trainer
    assert !(users(:jim).is_administrator)
    assert users(:igor).is_administrator
    assert users(:igor).is_trainer
    assert !(users(:joe).is_trainer)
    assert !(users(:joe).is_administrator)
  end
end
