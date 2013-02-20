class Series < ActiveRecord::Base
  attr_accessible :name, :exercise, :order, :repeat_count, :weight
  
  belongs_to :exercise
end
