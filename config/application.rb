require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module FarHorizonsApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    debugger if ENV["DEBUG"] && Rails.env.development?
    
    # Start support services
    pid = `ps x | grep redis-server.*6380 | grep -v grep`.split[0]
    unless pid
      Process.detach( spawn( 
          "redis-server ./config/redis-fh.conf > ./log/redis-console.log" ) )
    end
    pid = `ps x | grep mapserver | grep -v grep`.split[0]
    unless pid
      Process.detach( spawn( "bin/mapserver localhost /data/map.tiles" ) )
    end
  end
end
