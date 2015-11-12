class IndexController < ActionController::Base

  def index
    render layout: false
  end

  def landing_page
    render layout: false
  end

  def login
    render layout: false
  end

end