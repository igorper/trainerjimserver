class LandingController < ActionController::Base

  def landing_page
    render layout: 'landing_layout'
  end

  def login
    render layout: 'landing_layout'
  end

end