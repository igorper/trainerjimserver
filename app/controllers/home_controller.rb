class HomeController < ApplicationController
  def index
    # Display the list of available training programmes:
  end
  
  def soon
    render :layout => 'noframe'
  end
end
