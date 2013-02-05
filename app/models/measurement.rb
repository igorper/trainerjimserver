class Measurement < ActiveRecord::Base
  attr_accessible :data, :user_id
  
  belongs_to :user
end

  
class MeasurementSubmission < Measurement
  attr_accessor :email, :password, :file_upload_data
  attr_accessible :email, :password, :file_upload_data
end