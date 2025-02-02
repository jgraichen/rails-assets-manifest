# frozen_string_literal: true

module Rails::Assets::Manifest
  module Helper
    URI_REGEXP = %r{^[-a-z]+://|^(?:cid|data):|^//}i

    def path_to_asset(source, options)
      if (entry = ::Rails::Assets::Manifest.lookup(path_with_extname(source, options)))
        # Directly return the entry src if it is a fully qualified URL.
        # Otherwise, Rails will join the URL with `relative_url_root`
        # and/or asset host.
        return entry.src if URI_REGEXP.match?(entry.src)

        if entry.src[0] == '/'
          # When the asset name starts with a slash, Rails will skip an
          # additional lookup via `#compute_asset_path` and directly use
          # the provided path. As we already have looked up the manifest
          # entry here, we can pass the entry source, but only *if* it
          # starts with a slash.
          return super(entry.src, options)
        end
      end

      super
    end

    def compute_asset_path(name, _options)
      ::Rails::Assets::Manifest.lookup!(name).src
    rescue EntryMissing
      return super if Rails::Assets::Manifest.passthrough?

      raise
    end

    def asset_integrity(name, options)
      ::Rails::Assets::Manifest.lookup!(path_with_extname(name, options)).integrity
    rescue EntryMissing
      return super if Rails::Assets::Manifest.passthrough?

      raise
    end

    def javascript_include_tag(*sources, integrity: nil, **kwargs)
      return super(*sources, **kwargs) unless manifest_use_integrity?(integrity)

      with_integrity(sources, integrity, :javascript, **kwargs) do |source, options|
        super(source, options)
      end
    end

    def stylesheet_link_tag(*sources, integrity: nil, **kwargs)
      return super(*sources, **kwargs) unless manifest_use_integrity?(integrity)

      with_integrity(sources, integrity, :stylesheet, **kwargs) do |source, options|
        super(source, options)
      end
    end

    private

    def manifest_use_integrity?(option)
      return false unless secure_request_context?

      option || option.nil?
    end

    # http://www.w3.org/TR/SRI/#non-secure-contexts-remain-non-secure
    def secure_request_context?
      respond_to?(:request) && request && (request.local? || request.ssl?)
    end

    def with_integrity(sources, required, type, **kwargs)
      sources.map do |source|
        path = path_with_extname(source, type: type, **kwargs)

        # integrity hash passed directly
        if required.is_a?(String)
          next yield(source, {integrity: required, crossorigin: 'anonymous', **kwargs})
        end

        # Explicit passed `true` option
        if required
          integrity = asset_integrity(source, type: type, **kwargs)

          raise IntegrityMissing.new "SRI missing for #{path}" unless integrity

          next yield(source, {integrity: integrity, crossorigin: 'anonymous', **kwargs})
        end

        # No integrity option passed or `nil` default from above
        if required.nil?
          entry = ::Rails::Assets::Manifest.lookup(path)

          # Only if it is an asset from our manifest and there is an
          # integrity we default to adding one
          if entry&.integrity
            next yield(source, {integrity: entry.integrity, crossorigin: 'anonymous', **kwargs})
          end
        end

        yield(source, kwargs)
      end.join.html_safe
    end

    def path_with_extname(path, options)
      path = path.to_s
      "#{path}#{compute_asset_extname(path, options)}"
    end
  end
end
