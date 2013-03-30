  class MeasurementComment < ActiveRecord::Base
  attr_accessible :timestamp, :comment, :series_execution
  
  belongs_to :series_execution
end
