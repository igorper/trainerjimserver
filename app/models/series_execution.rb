# == Schema Information
#
# Table name: series_executions
#
#  id               :integer          not null, primary key
#  start_timestamp  :integer
#  end_timestamp    :integer
#  num_repetitions  :integer
#  weight           :integer
#  rest_time        :integer
#  measurement_id   :integer          not null
#  duration_seconds :integer          default(0)
#

class SeriesExecution < ActiveRecord::Base
  # attr_accessible :start_timestamp, :end_timestamp,
    # :num_repetitions, :weight, :rest_time, :measurement, :duration_seconds,
    # :measurement_comments

  belongs_to :measurement
  belongs_to :series
  has_many :measurement_comments
  
  def as_json(options={})
    super(options.merge({:include => :measurement_comments}))    
  end
end
