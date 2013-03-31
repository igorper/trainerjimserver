class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :id, :email, :password, :password_confirmation, :remember_me,
                  :admin, :full_name, :is_trainer
  
  has_many :measurements, :dependent => :delete_all
  
  @@RoleAdmin = 0b1
  
  def admin?
    (self.role & @@RoleAdmin) != 0
  end
  
  def admin=(bool_value)
    self.role = (bool_value ? (@role | @@RoleAdmin) : (@role & ~@@RoleAdmin))
  end
  
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
end
