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

        def instance
          @instance ||= begin
            Manifest.new \
              Rails.application.config.assets.manifest,
              cache: false
          end
        end
      end
    end
  end
end
