class User < ActiveRecord::Base
  has_secure_password
  
  attr_accessible :email, :password, :password_digest, :role
  
  @@RoleAdmin = 0b1
  
  def admin?
    (self.role & @@RoleAdmin) != 0
  end
  
  def admin=(bool_value)
    self.role = (bool_value ? (@role | @@RoleAdmin) : (@role & ~@@RoleAdmin))
  end
end
