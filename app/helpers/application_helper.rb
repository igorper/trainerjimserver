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
  ### I18N
  ##
  
  # @return   the translation of the given key, or the key if its translation could not be found.
  #
  # Example of use: +jim_t("Some content that needs translation...")+
  def jim_t(key, locale = I18n.locale)
    translation = I18nString.joins(:i18n_key).where(locale: locale, i18n_keys: {key: key}).first 
    if translation then
      return translation.data
    else
      return key
    end
  end
  ##
  ### END: I18N
  ##############################################################################
  
  
  
  ##############################################################################
  ### DEVISE (stuff for login/registration panels)
  ##
  def resource_name
    :user
  end
  
  def login_panel_url
    welcome_url
  end
  
  def signup_url
    welcome_url
  end
  
  def login_url
    welcome_url
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
