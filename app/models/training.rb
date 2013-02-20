class Training < ActiveRecord::Base
  attr_accessible :name, :user, :trainer, :exercises
  
  belongs_to :user
  belongs_to :trainer, :class_name => 'User', :foreign_key => 'trainer_id'
  has_many :exercises
end
