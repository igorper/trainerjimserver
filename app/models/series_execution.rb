class SeriesExecution < ActiveRecord::Base
  attr_accessible :start_timestamp, :end_timestamp, :exercise, :num_repetitions, :weight, :rest_time, :measurement, :duration_seconds
 
  belongs_to :exercise
  belongs_to :measurement
end