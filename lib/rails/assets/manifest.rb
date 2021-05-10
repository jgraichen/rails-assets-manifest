# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'

require 'rails/assets/manifest/version'

module Rails
  module Assets
    module Manifest
      require 'rails/assets/manifest/manifest'
      require 'rails/assets/manifest/helper'
      require 'rails/assets/manifest/railtie' if defined?(Rails::Railtie)

      class ManifestMissing < StandardError; end

      class ManifestInvalid < StandardError; end

      class EntryMissing < StandardError; end

      class IntegrityMissing < StandardError; end

      class << self
        delegate :lookup, :lookup!, to: :instance

        attr_reader :instance

        def prepare!
          @instance = begin
            config = Rails.application.config

            Manifest.new \
              files: config.assets.manifests,
              cache: config.cache_classes
          end
        end

        def eager_load!
          return unless @instance

          @instance.eager_load!
        end

        def passthrough?
          Rails.application.config.assets.passthrough
        end
      end
    end
  end
end
