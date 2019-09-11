# frozen_string_literal: true

module Rails
  module Assets
    module Manifest
      class Railtie < ::Rails::Railtie
        # If this plugin is used with sprockets this option
        # already exists and must not be overriden. Otherwise
        # all sprockets default options are removed breaking
        # sprockets.
        unless config.respond_to?(:assets)
          config.assets = ::ActiveSupport::OrderedOptions.new
        end

        # Path where the manifest files are loaded from.
        config.assets.manifests = ['public/assets/manifest.json']

        # If set to true missing assets will not raise an
        # exception but are passed through to sprockets
        # or rails own asset methods.
        config.assets.passthrough = false

        config.after_initialize do |_|
          ActiveSupport.on_load(:action_view) do
            include Helper
          end
        end

        initializer 'rails-assets-manifest' do |app|
          ::Rails::Assets::Manifest.instance
        end
      end
    end
  end
end
