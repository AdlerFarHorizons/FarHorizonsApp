FarHorizonsApp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = true

  # Do not eager load code on boot.
  config.eager_load = true

  # Don't show full error reports and enable caching.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log
  
  config.log_level = :info

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
end

# From https://gist.github.com/MyArtChannel/941174 :
# 
# Add this to the end of your development.rb and add 
#
# gem 'pry'
#
# to your Gemfile and run bundle to install.
 
silence_warnings do
  begin
    require 'pry'
    IRB = Pry
  rescue LoadError
  end
end
