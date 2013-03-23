class Conversation < ActiveRecord::Base
  attr_accessible :user1, :user2, :text, :date, :measurement
  
  belongs_to :user1, :class_name => "User", :foreign_key => "user1_id"
  belongs_to :user2, :class_name => "User", :foreign_key => "user2_id"
  belongs_to :measurement
end
