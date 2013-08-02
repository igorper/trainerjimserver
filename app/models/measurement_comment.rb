# == Schema Information
#
# Table name: measurement_comments
#
#  id                  :integer          not null, primary key
#  timestamp           :integer
#  comment             :string(255)
#  series_execution_id :integer
#

  class MeasurementComment < ActiveRecord::Base
  # attr_accessible :timestamp, :comment, :series_execution
  
  belongs_to :series_execution
end
