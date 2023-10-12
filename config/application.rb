require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MilloraApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = { address: 'smtp.gmail.com', port: 587, domain: 'gmail.com', user_name: Rails.application.credentials.gmail, password: Rails.application.credentials.gmail_pass, authentication: 'plain', enable_starttls_auto: true}

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
