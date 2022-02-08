# frozen_string_literal: true

module Rails
  module Assets
    module Manifest
      class Railtie < ::Rails::Railtie
        config.assets_manifest = ::ActiveSupport::OrderedOptions.new

        # Path where the manifest file is loaded from.
        config.assets_manifest.path = 'public/assets/assets-manifest.json'

        # If set to true missing assets will not raise an exception but are
        # passed through to sprockets or rails own asset methods.
        config.assets_manifest.passthrough = false

        config.after_initialize do |_|
          ActiveSupport.on_load(:action_view) do
            prepend Helper
          end
        end

        config.to_prepare do
          ::Rails::Assets::Manifest.prepare!
        end

        config.before_eager_load do
          ::Rails::Assets::Manifest.eager_load!
        end
      end
    end
  end
end
