  class MeasurementComment < ActiveRecord::Base
  attr_accessible :timestamp,:comment,:series_execution
  
  belongs_to :series_execution, :class_name => "SeriesExecution", :foreign_key => "series_executions_id"
end
