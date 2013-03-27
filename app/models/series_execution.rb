class SeriesExecution < ActiveRecord::Base
  attr_accessible :start_timestamp, :end_timestamp, :exercise, :num_repetitions, :weight, :rest_time, :measurement, :duration_seconds, :measurement_comments
 
  belongs_to :exercise
  belongs_to :measurement
  has_many :measurement_comments, :class_name => "MeasurementComment", :foreign_key => "series_executions_id"
  
  
  def as_json(options={})
    super(options.merge({:include => :measurement_comments}))    
  end
end