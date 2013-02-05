class Measurement < ActiveRecord::Base
  attr_accessible :data
  
  belongs_to :user
end
