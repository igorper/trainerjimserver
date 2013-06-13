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
  
  def signup_url
    if Rails.env.production? || Rails.env.staging? then
      registration_url(resource_name, :protocol => 'https')
    else
      registration_url(resource_name)
    end
  end
  
  def login_url
    if Rails.env.production? || Rails.env.staging? then
      session_url(resource_name, :protocol => 'https')
    else
      session_url(resource_name)
    end
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
