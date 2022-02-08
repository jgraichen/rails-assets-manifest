# frozen_string_literal: true

module Rails::Assets::Manifest
  class Manifest
    attr_reader :path

    def initialize(path, cache: true)
      @path = Rails.root.join(path).to_s.freeze
      @cache = cache
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
          Can't find #{name} in #{path}. Your manifest contain:
          #{JSON.pretty_generate(data.keys)}
        ERROR
      end
    end

    def key?(name)
      data.key?(name.to_s)
    end

    def eager_load!
      data
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
      {}.tap do |entries|
        JSON.parse(File.read(path)).each_pair do |key, entry|
          if entry.is_a?(String)
            entries[key] = Entry.new(entry, nil)
          elsif entry.is_a?(Hash) && entry.key?('src')
            entries[key] = Entry.new(entry['src'], entry['integrity'])
          else
            raise "Invalid manifest entry: #{entry.inspect}"
          end
        end
      end
    rescue Errno::ENOENT => e
      raise ManifestMissing.new <<~ERROR
        Asset manifest does not exist: #{e}
      ERROR
    rescue StandardError => e
      raise ManifestInvalid.new <<~ERROR
        Asset manifest could not be loaded: #{e}
      ERROR
    end
  end
end
