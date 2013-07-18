class Exercise < ActiveRecord::Base
  # attr_accessible :training, :series, :order, :exercise_type, :id
  
  # TODO: dry-out (currently defined in exercise, series_execution and in training-workouts.js)
  validates_inclusion_of :guidance_type, :in => ["duration", "tempo", "manual"]
  
  belongs_to :training
  has_many :series, :dependent => :delete_all
  belongs_to :exercise_type
end
