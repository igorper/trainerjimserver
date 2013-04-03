module ApplicationHelper
  ##############################################################################
  ### NAVIGATION
  ##
  def controller?(name)
    return controller_name == name.to_s
  end
  ##
  ### END: NAVIGATION
  ##############################################################################
  
  
  
  ##############################################################################
  ### DEVISE (stuff for login/registration panels)
  ##
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  ##
  ### END: DEVISE (stuff for login/registration panels)
  ##############################################################################
end
