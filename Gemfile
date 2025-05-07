# frozen_string_literal: true

source 'https://rubygems.org'

# Load gem's dependencies
gemspec

gem 'rails', require: false
gem 'sprockets-rails', require: false # not included by default in Rails 7+
gem 'sqlite3', require: false

gem 'rake', '~> 13.0'
gem 'rspec', '~> 3.0'
gem 'rspec-rails'

gem 'rubocop-config', github: 'jgraichen/rubocop-config', tag: 'v14', require: false

group :development do
  gem 'appraisal'
end
