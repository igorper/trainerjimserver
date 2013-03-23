  class MeasurementComment < ActiveRecord::Base
  attr_accessible :timestamp,:comment,:measurement
  
  belongs_to :measurement
end
