# frozen_string_literal: true

require_relative 'boot'

VARIANT = ENV['VARIANT'].to_s.split(',')

if VARIANT.empty?
  require 'rails/all'
else
  require 'active_model/railtie'
  require 'active_job/railtie'
  require 'active_record/railtie'
  require 'active_storage/engine'
  require 'action_controller/railtie'
  require 'action_mailer/railtie'
  require 'action_mailbox/engine' if Rails::VERSION::MAJOR > 6
  require 'action_text/engine' if Rails::VERSION::MAJOR > 6
  require 'action_view/railtie'
  require 'action_cable/engine'
  require 'rails/test_unit/railtie'
end

if VARIANT.include?('no-sprockets')
  SPROCKETS = false
else
  require 'sprockets/rails'
  SPROCKETS = true
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.assets_manifest.passthrough = true

    config.relative_url_root = '/relroot'
    config.asset_host = 'cdn.example.org'
  end
end
