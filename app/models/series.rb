class Series < ActiveRecord::Base
  # :weight [integer] - the amount of weight to use in this series (unit is kg).
  # :rest_time [integer] - time to rest after this series (in seconds).
  # attr_accessible :name, :exercise, :order, :repeat_count, :weight, :rest_time
  
  belongs_to :exercise
end
