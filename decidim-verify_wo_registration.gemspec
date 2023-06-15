# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'decidim/verify_wo_registration/version'

Gem::Specification.new do |s|
  s.version = Decidim::VerifyWoRegistration.version
  s.authors = ['Oliver Valls']
  s.email = ['oliver.vh@coditramuntana.com']
  s.license = 'MIT'
  s.homepage = 'https://github.com/CodiTramuntana/decidim-verify_wo_registration'
  s.required_ruby_version = '>= 2.5'

  s.name = 'decidim-verify_wo_registration'
  s.summary = 'Adds the hability for proposals and budgets components to allow users to give support without being registered.'
  s.description = 'Adds the hability for proposals and budgets components to allow users to give support without being registered. Enabling this feature the user is requested for verification and then, on success, logged in in a 30min session..'

  s.files = Dir['{app,config,lib}/**/*', 'LICENSE-MIT.txt', 'Rakefile', 'README.md']

  
  s.add_dependency 'decidim-budgets', Decidim::VerifyWoRegistration.version
  s.add_dependency 'decidim-core', Decidim::VerifyWoRegistration.version
  s.add_dependency 'decidim-proposals', Decidim::VerifyWoRegistration.version
  s.add_development_dependency 'decidim', Decidim::VerifyWoRegistration.version
  s.add_development_dependency 'decidim-dev', Decidim::VerifyWoRegistration.version
  s.add_development_dependency 'decidim-participatory_processes', Decidim::VerifyWoRegistration.version
end
