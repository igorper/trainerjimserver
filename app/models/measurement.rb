# == Schema Information
#
# Table name: measurements
#
#  id           :integer          not null, primary key
#  trainee_id   :integer          not null
#  trainer_id   :integer
#  training_id  :integer          not null
#  data         :binary
#  start_time   :datetime
#  end_time     :datetime
#  rating       :integer
#  created_at   :datetime
#  updated_at   :datetime
#  trainer_seen :boolean          default(FALSE), not null
#  comment      :string(255)
#

class Measurement < ActiveRecord::Base
  # attr_accessible :id, :data, :trainee, :trainer, :start_time, :end_time, :rating,
    # :training, :series_executions, :measurement_comments, :trainer_seen, :comment, :created_at
  
  belongs_to :trainee, :class_name => "User", :foreign_key => 'trainee_id'
  belongs_to :trainer, :class_name => "User", :foreign_key => 'trainer_id'
  belongs_to :training
  has_many :series_executions
  has_many :measurement_comments
end
