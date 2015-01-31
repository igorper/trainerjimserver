# == Schema Information
#
# Table name: series
#
#  id                         :integer          not null, primary key
#  exercise_id                :integer          not null
#  order                      :integer
#  repeat_count               :integer
#  weight                     :integer
#  rest_time                  :integer          default(0), not null
#  created_at                 :datetime
#  updated_at                 :datetime
#  duration_after_repetition  :integer
#  duration_up_repetition     :integer
#  duration_middle_repetition :integer
#  duration_down_repetition   :integer
#

class Series < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  
  # :weight [integer] - the amount of weight to use in this series (unit is kg).
  # :rest_time [integer] - time to rest after this series (in seconds).
  
  belongs_to :exercise

  amoeba do
    enable
  end
end
