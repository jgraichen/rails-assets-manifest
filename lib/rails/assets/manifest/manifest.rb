# frozen_string_literal: true

module Rails::Assets::Manifest
  class Manifest
    attr_reader :path

    Entry = Struct.new(:src, :integrity)

    def initialize(path, cache: false)
      @path = path.to_s.freeze
      @cache = cache

      load! if cache?
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
          #{JSON.pretty_generate(@data.keys)}
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

    def load!
      @data = JSON.parse(File.read(path)).transform_values do |entry|
        if entry.is_a?(String)
          Entry.new(entry, nil)
        elsif entry.is_a?(Hash)
          Entry.new(entry['src'], entry['integrity'])
        else
          raise InvalidManifest, \
            "Manifest contains invalid entry: #{entry.inspect}"
        end
      end
    end

    def load
      if File.readable?(path)
        load!
      else
        []
      end
    end
  end
end
