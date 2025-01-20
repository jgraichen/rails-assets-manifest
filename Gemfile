# frozen_string_literal: true

source 'https://rubygems.org'

# Load gem's dependencies
gemspec

gem 'net-smtp', require: false # not bundled in Ruby 3.1+
gem 'rails', require: false
gem 'sprockets-rails', require: false # not included by default in Rails 7+
gem 'sqlite3', require: false

gem 'rake', '~> 13.0'
gem 'rspec', '~> 3.0'
gem 'rspec-rails', '~> 6.0'

gem 'pry'
gem 'rubocop-config', github: 'jgraichen/rubocop-config', ref: '9f3e5cd0e519811a7f615f265fca81a4f4e843b9', require: false

group :development do
  gem 'appraisal'
end
