# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION= {git: "https://github.com/decidim/decidim", branch: 'develop'}
gem "decidim-core", DECIDIM_VERSION
gem "decidim-proposals", DECIDIM_VERSION
gem "decidim-budgets", DECIDIM_VERSION
gem "decidim-verify_wo_registration", path: "."

gem "puma"
gem "uglifier"

group :development, :test do
  gem "decidim", DECIDIM_VERSION
  gem "bootsnap"
  gem "pry"

  gem "decidim-dev", git: "https://github.com/decidim/decidim"
end

group :development do
  gem "faker", "~> 1.9"
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end
