class Series < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  
  # :weight [integer] - the amount of weight to use in this series (unit is kg).
  # :rest_time [integer] - time to rest after this series (in seconds).
  
  belongs_to :exercise
end
