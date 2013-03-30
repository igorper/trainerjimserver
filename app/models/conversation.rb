class Conversation < ActiveRecord::Base
  attr_accessible :sender, :text, :date, :measurement
  
  belongs_to :sender, :class_name => :User, :foreign_key => :sender_id
  belongs_to :measurement
end
