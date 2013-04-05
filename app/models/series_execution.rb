class SeriesExecution < ActiveRecord::Base
  attr_accessible :start_timestamp, :end_timestamp, :exercise_type,
    :num_repetitions, :weight, :rest_time, :measurement, :duration_seconds,
    :measurement_comments, :exercise_type_id
 
  belongs_to :exercise_type
  belongs_to :measurement
  has_many :measurement_comments
  
  def as_json(options={})
    super(options.merge({:include => :measurement_comments}))    
  end
end