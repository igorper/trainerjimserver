require Rails.root.join('config', 'environments', 'production')

Trainerjim::Application.configure do
  config.action_mailer.delivery_method = :file
  config.action_mailer.default_url_options = { :host => config.trainerjim_server + ':3001' }
end
