class LandingController < ActionController::Base

  def landing
    render layout: 'landing_layout'
  end

  def login
    render layout: 'landing_layout'
  end

end