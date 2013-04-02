class HomeController < ApplicationController
  
  include AjaxHelper
  
  def index
    if user_signed_in? then
      render 'training_list'
    end
    # Display the list of available training programmes:
  end
  
  def soon
    render :layout => 'basic'
  end
  
  def welcome
    if user_signed_in? then
      redirect_to home_url
    else
      render :layout => 'basic'
    end
  end
  
  # @param email
  def m_subscribe
    ns = NewsletterSubscription.create(:email => params[:email])
    if ns && ns.save then
      ajax_render true
    else
      ajax_render_symerr :invalid_email
    end
  end
end
