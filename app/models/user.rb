class User < ActiveRecord::Base
  has_secure_password
  
  attr_accessible :id, :email, :password, :admin, :first_name, :last_names
  
  has_many :measurements, :dependent => :delete_all
  
  @@RoleAdmin = 0b1
  
  def admin?
    (self.role & @@RoleAdmin) != 0
  end
  
  def admin=(bool_value)
    self.role = (bool_value ? (@role | @@RoleAdmin) : (@role & ~@@RoleAdmin))
  end
  
  def display_name()
    if self.first_name.blank? and self.last_names.blank? then
      require 'mail_utils'
      return MailUtils::extract_display_name(self.email)
    else
      if self.first_name.blank? then
        return self.last_names
      elsif self.last_names.blank? then
        return self.first_name
      else
        return self.first_name + " " + self.last_names
      end
    end
  end
  
  def unique_display_name()
    "#{self.display_name} (#{self.email})"
  end
end
