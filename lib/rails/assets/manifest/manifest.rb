# frozen_string_literal: true

module Rails::Assets::Manifest
  class Manifest
    attr_reader :path

    def initialize(path:, cache: true)
      @path = path.to_s.freeze
      @cache = cache

      data if cache?
    end

    def cache?
      @cache
    end

    def lookup(name)
      data[name.to_s].presence
    end

    def lookup!(name)
      lookup(name) || begin
        raise EntryMissing.new <<~ERROR
          Can't find #{name} in #{path}. Your manifest contains:
          #{JSON.pretty_generate(data.keys)}
        ERROR
      end
    end

    private

    Entry = Struct.new(:src, :integrity) do
      def integrity?
        integrity.present?
      end
    end

    def data
      if cache?
        @data ||= load
      else
        load
      end
    end

    def load
      JSON.parse(File.read(path)).transform_values do |entry|
        if entry.is_a?(String)
          Entry.new(entry, nil)
        elsif entry.is_a?(Hash)
          Entry.new(entry.fetch('src'), entry['integrity'])
        else
          raise "Invalid entry: #{entry.inspect}"
        end
      end
    rescue Errno::ENOENT => e
      raise ManifestMissing.new <<~ERROR
        Asset manifest does not exist: #{e}
      ERROR
    rescue => e
      raise ManifestInvalid.new <<~ERROR
        Asset manifest could not be loaded: #{e}
      ERROR
    end
  end
end
