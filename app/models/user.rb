class User < ActiveRecord::Base
  has_secure_password
  
  attr_accessible :id, :email, :password, :admin, :full_name
  
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
