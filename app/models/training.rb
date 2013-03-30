class Training < ActiveRecord::Base
  attr_accessible :name, :exercises, :trainee
  
  has_many :exercises
  belongs_to :trainee, :class_name => "User", :foreign_key => 'trainee_id'
end
