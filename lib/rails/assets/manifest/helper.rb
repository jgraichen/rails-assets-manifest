# frozen_string_literal: true

module Rails::Assets::Manifest
  module Helper
    def compute_asset_path(name, **_kwargs)
      ::Rails::Assets::Manifest.lookup!(name).src
    end

    def asset_integrity(name, **kwargs)
      ::Rails::Assets::Manifest.lookup!(path_with_extname(name, **kwargs)).integrity
    end

    def javascript_include_tag(*sources, integrity: nil, **kwargs)
      return super(*sources, **kwargs) unless compute_integrity?(integrity)

      with_integrity(sources, integrity, type: :javascript, **kwargs) do |source, options|
        super(source, options)
      end
    end

    def stylesheet_link_tag(*sources, integrity: nil, **kwargs)
      return super(*sources, **kwargs) unless compute_integrity?(integrity)

      with_integrity(sources, integrity, type: :stylesheet, **kwargs) do |source, options|
        super(source, options)
      end
    end

    private

    def compute_integrity?(option)
      return false unless secure_subresource_integrity_context?

      option || option.nil?
    end

    def with_integrity(sources, required, **kwargs)
      sources.map do |source|
        integrity = asset_integrity(source, **kwargs)

        if required && !integrity
          raise IntegrityMissing.new <<~ERROR
            SRI missing for #{path_with_extname(source, kwargs)}
          ERROR
        end

        yield(source, integrity: integrity, **kwargs)
      end.join.html_safe
    end

    def secure_subresource_integrity_context?
      respond_to?(:request) && (request&.local? || request&.ssl?)
    end

    def path_with_extname(path, options)
      path = path.to_s
      "#{path}#{compute_asset_extname(path, options)}"
    end
  end
end
