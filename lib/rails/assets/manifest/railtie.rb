# frozen_string_literal: true

module Rails
  module Assets
    module Manifest
      class Railtie < ::Rails::Railtie
        config.assets = ::ActiveSupport::OrderedOptions.new
        config.assets.manifest = 'public/assets/manifest.json'

        config.after_initialize do |_|
          ActiveSupport.on_load(:action_view) do
            include Helper
          end
        end

        initializer 'rails-assets-manifest' do |app|
          ::Rails::Assets::Manifest.instance if server?
        end

        private

        def server?
          !(console? || generator? || rake?)
        end

        def console?
          defined?(Rails::Console)
        end

        def generator?
          defined?(Rails::Generators)
        end

        def rake?
          File.basename($0) == "rake"
        end
      end
    end
  end
end
