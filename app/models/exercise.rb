# == Schema Information
#
# Table name: exercises
#
#  id               :integer          not null, primary key
#  training_id      :integer          not null
#  exercise_type_id :integer          not null
#  order            :integer
#  created_at       :datetime
#  updated_at       :datetime
#  machine_setting  :string(255)
#

class Exercise < ActiveRecord::Base
  # attr_accessible :training, :series, :order, :exercise_type, :id
  
  belongs_to :training
  has_many :series, :dependent => :delete_all
  belongs_to :exercise_type
end
