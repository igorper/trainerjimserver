class HomeController < ApplicationController
  def index
  end
  
  def soon
    render :layout => 'noframe'
  end
end
