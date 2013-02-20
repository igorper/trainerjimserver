class Exercise < ActiveRecord::Base
  attr_accessible :name, :training, :series, :order
  
  belongs_to :training
  has_many :series
end
