# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'decidim/verify_wo_registration/version'

Gem::Specification.new do |s|
  s.version = Decidim::VerifyWoRegistration.version
  s.authors = ['Oliver Valls']
  s.email = ['oliver.vh@coditramuntana.com']
  s.license = 'MIT'
  s.homepage = 'https://github.com/decidim/decidim-verify_wo_registration'
  s.required_ruby_version = '>= 2.5'

  s.name = 'decidim-verify_wo_registration'
  s.summary = 'Adds the hability for proposals and budgets components to allow users to give support without being registered.'
  s.description = 'Adds the hability for proposals and budgets components to allow users to give support without being registered. Enabling this feature the user is requested for verification and then, on success, logged in in a 30min session..'

  s.files = Dir['{app,config,lib}/**/*', 'LICENSE-MIT.txt', 'Rakefile', 'README.md']

  DECIDIM_VER = '>= 0.20'
  s.add_dependency 'decidim-budgets', DECIDIM_VER
  s.add_dependency 'decidim-core', DECIDIM_VER
  s.add_dependency 'decidim-proposals', DECIDIM_VER
  s.add_development_dependency 'decidim', DECIDIM_VER
  s.add_development_dependency 'decidim-dev', DECIDIM_VER
  s.add_development_dependency 'decidim-participatory_processes', DECIDIM_VER
end
