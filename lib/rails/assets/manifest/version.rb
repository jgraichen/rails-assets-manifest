# frozen_string_literal: true

module Rails
  module Assets
    module Manifest
      module VERSION
        MAJOR = 1
        MINOR = 1
        PATCH = 0
        STAGE = nil

        STRING = [MAJOR, MINOR, PATCH, STAGE].reject(&:nil?).join('.')

        def self.to_s
          STRING
        end
      end
    end
  end
end
