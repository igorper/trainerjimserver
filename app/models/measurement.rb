class Measurement < ActiveRecord::Base
  # attr_accessible :id, :data, :trainee, :trainer, :start_time, :end_time, :rating,
    # :training, :series_executions, :measurement_comments, :trainer_seen, :comment, :created_at
  
  belongs_to :trainee, :class_name => "User", :foreign_key => 'trainee_id'
  belongs_to :training
  has_many :series_executions, -> {order(:id)}
  has_many :measurement_comments
end
