class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  if Rails.env.production? then
    devise :database_authenticatable,
      :recoverable, :rememberable, :trackable, :validatable
  else
    devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :trackable, :validatable
  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :id, :email, :password, :password_confirmation, :remember_me,
    :full_name, :trainer, :roles
  
  belongs_to :trainer, :class_name => "User", :foreign_key => 'trainer_id'
  has_many :measurements, :dependent => :delete_all
  has_and_belongs_to_many :roles
  
  def display_name()
    if self.full_name.blank? then
      require 'mail_utils'
      return MailUtils::extract_display_name(self.email)
    else
      return self.full_name
    end
  end
  
  def unique_display_name()
    "#{self.display_name} (#{self.email})"
  end
  
  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end
  
  def administrator?
    return !!self.roles.find_by_name(Role.administrator)
  end
  
  def trainer?
    return !!self.roles.find_by_name(Role.trainer)
  end
end
