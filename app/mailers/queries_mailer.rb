class QueriesMailer < ActionMailer::Base
  default from: "noreply@trainerjim.com"

  def general_query(email, message)
    @email = email
    @message = message
    mail(to: 'hello@trainerjim.com',
         subject: "Query from #{email}",
         reply_to: email)
  end
end
