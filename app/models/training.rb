class Training < ActiveRecord::Base
  attr_accessible :name, :exercises
  
  has_many :exercises
end
