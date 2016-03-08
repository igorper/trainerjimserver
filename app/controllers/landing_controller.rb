class LandingController < ActionController::Base

  before_action :set_locale

  def set_locale
    I18n.locale = params[:l] || I18n.default_locale
  end

  def landing
    render layout: 'landing_layout'
  end

  def login
    render layout: 'landing_layout'
  end

end