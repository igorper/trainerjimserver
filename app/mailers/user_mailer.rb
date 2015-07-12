class UserMailer < ActionMailer::Base
  default from: "noreply@trainerjim.com"

  def activated_account(new_user, password, creator)
    @user = new_user
    @creator = creator
    @password = password
    mail(to: @user.email, subject: 'Welcome to TrainerJim')
  end

end
