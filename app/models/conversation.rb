class Conversation < ActiveRecord::Base
  attr_accessible :user1, :user2, :text, :datum, :measurement
  
  has_one :user1, :class_name => "User", :foreign_key => "user1_id"
  has_one :user2, :class_name => "User", :foreign_key => "user2_id"
  belongs_to :measurement
end
