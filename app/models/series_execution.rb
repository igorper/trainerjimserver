class SeriesExecution < ActiveRecord::Base
  attr_accessible :start_timestamp, :end_timestamp, :exercise, :num_repetitions, :weight, :rest_time, :measurement
 
  belongs_to :exercise
  belongs_to :measurement
end