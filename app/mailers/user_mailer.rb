class UserMailer < ActionMailer::Base
  default from: "noreply@trainerjim.com"

  add_template_helper(UserHelper)

  def user_created(new_user, creator_user)
    @user = new_user
    @creator_user = creator_user
    mail(to: 'hello@trainerjim.com', subject: 'New TrainerJim User')
  end

end
