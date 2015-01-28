# == Schema Information
#
# Table name: trainings
#
#  id                   :integer          not null, primary key
#  trainee_id           :integer
#  name                 :string(255)
#  original_training_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#  historical           :boolean
#

class Training < ActiveRecord::Base
  # attr_accessible :id, :name, :exercises, :trainee, :trainee_id, :original_training
  
  has_many :exercises, :dependent => :delete_all
  belongs_to :trainee, :class_name => "User", :foreign_key => 'trainee_id'
  belongs_to :original_training, :class_name => "Training", :foreign_key => 'original_training_id'
  
  def common?
    trainee.nil?
  end
end
