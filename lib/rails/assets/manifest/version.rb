# frozen_string_literal: true

module Rails
  module Assets
    module Manifest
      module VERSION
        MAJOR = 3
        MINOR = 0
        PATCH = 1
        STAGE = nil

        STRING = [MAJOR, MINOR, PATCH, STAGE].compact.join('.')

        def self.to_s
          STRING
        end
      end
    end
  end
end
