# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-aaps/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-aaps'
  spec.version       = Omniauth::Aaps::VERSION
  spec.authors       = ['Dave Sloan']
  spec.email         = ['daveksloan@gmail.com']
  spec.summary       = %q{AAPS SSO}
  spec.description   = %q{AAPS SSO}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'builder'
  spec.add_dependency 'omniauth', '~> 1.0'
  spec.add_dependency 'omniauth-oauth2', '~> 1.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
