# frozen_string_literal: true

module Rails
  module Assets
    module Manifest
      class Railtie < ::Rails::Railtie
        config.assets = ::ActiveSupport::OrderedOptions.new
        config.assets.manifest = 'public/assets/manifest.json'

        config.after_initialize do |_app|
          ActiveSupport.on_load(:action_view) do
            include Helper
          end
        end
      end
    end
  end
end
