require File.dirname(__FILE__) + '/staging'

Trainerjim::Application.configure do
  config.log_level = :debug
  config.action_mailer.default_url_options = { :host => 'matej.trainerjim.com' }
end
