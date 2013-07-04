class UserMailer < ActionMailer::Base
  default from: "noreply@trainerjim.com"
  
  def subscribe_email(ns)
    mail(to: ns.email, subject: 'Welcome to TrainerJIM!')
  end
end
