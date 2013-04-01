class Training < ActiveRecord::Base
  attr_accessible :name, :exercises, :trainee, :original_training
  
  has_many :exercises
  belongs_to :trainee, :class_name => "User", :foreign_key => 'trainee_id'
  belongs_to :original_training, :class_name => "Training", :foreign_key => 'original_training_id'
end
