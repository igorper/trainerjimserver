class Exercise < ActiveRecord::Base
  attr_accessible :training, :series, :order, :exercise_type
  
  belongs_to :training
  has_many :series
  belongs_to :exercise_type
end
