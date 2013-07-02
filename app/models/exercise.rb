class Exercise < ActiveRecord::Base
  # attr_accessible :training, :series, :order, :exercise_type, :id
  
  belongs_to :training
  has_many :series, :dependent => :delete_all
  belongs_to :exercise_type
end
