# == Schema Information
#
# Table name: conversations
#
#  id             :integer          not null, primary key
#  sender_id      :integer
#  text           :string(255)
#  date           :datetime
#  measurement_id :integer          not null
#

class Conversation < ActiveRecord::Base
  # attr_accessible :sender, :text, :date, :measurement
  
  belongs_to :sender, :class_name => :User, :foreign_key => :sender_id
  belongs_to :measurement
end
