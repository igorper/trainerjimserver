# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
  # attr_accessible :name, :users
  
  has_and_belongs_to_many :users
  
  def self.administrator
    return 'Administrator'
  end
  
  def self.trainer
    return 'Trainer'
  end
end
