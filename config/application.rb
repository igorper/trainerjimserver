require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Trainerjim
  class Application < Rails::Application
    config.page_name = 'TrainerJim'
    config.jim_twitter_url = 'https://twitter.com/trainwithJIM/'
    config.jim_tumblr_url = 'http://trainerjim.tumblr.com/'
    config.jim_use_ssl_login_url = true
    
    config.to_prepare do
      Devise::SessionsController.layout "login" 
      Devise::RegistrationsController.layout "login" 
    end
    
    config.eager_load = false
    config.secret_key_base = 'H+4#XQvh=v2=fayR~y1w*yBKaeJ}mSI~'
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    
    files = Dir[Rails.root.join('app', 'assets', '{javascripts,stylesheets}', '**', '[^_]*.{js,css,erb}*')]
    files.map! {|file| file.sub(%r(#{Rails.root}/app/assets/(javascripts|stylesheets)/), '') }
    files.map! {|file| file.sub(%r(\.(coffee|scss|erb|scss\.erb)), '') }
    config.assets.precompile << files

    # Add the fonts path
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

    # Precompile additional assets
    config.assets.precompile += %w( *.svg *.eot *.woff *.ttf *.png *.jpg *.jpeg *.gif)
  end
end
