class HomeController < ApplicationController
  
  include AuthenticationHelper
  
  def index
    if logged_in? then
      render 'training_list'
    else
    end
    # Display the list of available training programmes:
  end
  
  def soon
    render :layout => 'noframe'
  end
  
  def welcome
    render :layout => 'noframe'
  end
end
