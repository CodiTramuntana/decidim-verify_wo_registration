# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

DECIDIM_VERSION = { git: 'https://github.com/decidim/decidim', branch: 'release/0.28-stable' }.freeze
gem 'decidim-budgets', DECIDIM_VERSION
gem 'decidim-core', DECIDIM_VERSION
gem 'decidim-proposals', DECIDIM_VERSION
gem 'decidim-verify_wo_registration', path: '.'

gem 'puma'
gem 'uglifier'

group :development, :test do
  gem 'bootsnap'
  gem 'decidim', DECIDIM_VERSION
  gem 'pry'

  gem 'decidim-dev', DECIDIM_VERSION
end

group :development do
  gem "faker", "~> 3.2"
  gem 'letter_opener_web', '~> 1.3'
  gem 'listen', '~> 3.1'
  gem 'spring', '~> 4.0'
  gem 'spring-watcher-listen', '~> 2.1'
  gem 'web-console', '~> 3.5'
end
