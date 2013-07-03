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
