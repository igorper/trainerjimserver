require File.dirname(__FILE__) + '/development'

Trainerjim::Application.configure do
  config.assets.digest = false
  config.assets.debug = false
  config.action_mailer.default_url_options = { :host => 'localhost' }
end
