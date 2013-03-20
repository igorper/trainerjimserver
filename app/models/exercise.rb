class Exercise < ActiveRecord::Base
  attr_accessible :training, :series, :order, :exercise_type
  
  belongs_to :training
  has_many :series
  has_one :exercise_type
end
