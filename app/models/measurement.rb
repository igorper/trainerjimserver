class Measurement < ActiveRecord::Base
  attr_accessible :id, :data, :trainee, :trainer, :start_time, :end_time, :rating,
    :training, :series_executions, :measurement_comments, :trainer_seen, :comment
  
  belongs_to :trainee, :class_name => "User", :foreign_key => 'trainee_id'
  belongs_to :trainer, :class_name => "User", :foreign_key => 'trainer_id'
  belongs_to :training
  has_many :series_executions
  has_many :measurement_comments
end