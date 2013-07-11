# == Schema Information
#
# Table name: measurements
#
#  id           :integer          not null, primary key
#  trainee_id   :integer          not null
#  trainer_id   :integer
#  training_id  :integer          not null
#  data         :binary
#  start_time   :datetime
#  end_time     :datetime
#  rating       :integer
#  created_at   :datetime
#  updated_at   :datetime
#  trainer_seen :boolean          default(FALSE), not null
#  comment      :string(255)
#

require 'test_helper'

class MeasurementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
