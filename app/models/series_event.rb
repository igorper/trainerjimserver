class SeriesEvent < ActiveRecord::Base
  attr_accessible :event_type, :measurement_id, :timestamp
end
