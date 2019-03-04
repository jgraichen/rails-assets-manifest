# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails/assets/manifest/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails-assets-manifest'
  spec.version       = Rails::Assets::Manifest::VERSION
  spec.authors       = ['Jan Graichen']
  spec.email         = ['jgraichen@altimos.de']

  spec.summary       = 'Load all rails assets from an external manifest.'
  spec.description   = 'Load all rails assets from an external manifest.'
  spec.homepage      = 'https://github.com/jgraichen/rails-assets-manifest'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/jgraichen/rails-assets-manifest'
  spec.metadata['changelog_uri']   = 'https://github.com/jgraichen/rails-assets-manifest/blob/master/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '> 4.2'
  spec.add_dependency 'railties', '> 4.2'

  spec.add_development_dependency 'bundler', '~> 2.0'
end
