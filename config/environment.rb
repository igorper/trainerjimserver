# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Trainerjim::Application.initialize!

Trainerjim::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => 'smtp.gmail.com',
    :port => 587,
    :user_name => 'hello@trainerjim.com',
    :password => 'Treniraj/Z/Jimom',
    :domain => 'trainerjim.com',
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end

ActionMailer::Base.default :from => 'hello@trainerjim.com'