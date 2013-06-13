class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_locale
 
  def set_locale
    I18n.locale = params[:l] || I18n.default_locale
  end
  
  def after_sign_out_path_for(resource_or_scope)
    welcome_url :protocol => 'http'
  end
end
