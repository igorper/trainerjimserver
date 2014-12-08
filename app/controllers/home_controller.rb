class HomeController < ApplicationController
  
  include AjaxHelper
  
  def welcome
    if user_signed_in?
      redirect_to workouts_url
    else
      render :layout => 'basic'
    end
  end
  
  # @param email
  def m_subscribe
    ns = NewsletterSubscription.create(:email => params[:email])
    if ns && ns.save
      ajax_render true
      UserMailer.subscribe_email(ns).deliver
    else
      ajax_error :invalid_email
    end
  end
end
