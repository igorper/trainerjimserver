class Measurement < ActiveRecord::Base
  attr_accessible :data, :user_id, :start_time, :end_time, :rating, :training, :series_executions
  
  belongs_to :user
  belongs_to :training  
  has_many :series_executions
  has_many :measurement_comment
end