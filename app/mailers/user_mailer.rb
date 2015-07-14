class UserMailer < ActionMailer::Base
  default from: "noreply@trainerjim.com"

  add_template_helper(UserHelper)

end
