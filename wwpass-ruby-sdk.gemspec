# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wwpass-ruby-sdk/version'

Gem::Specification.new do |spec|
  spec.name          = 'wwpass-ruby-sdk'
  spec.version       = '0.1.1'
  spec.authors       = ['Stanislav Panyushkin']
  spec.email         = ['opensource@wwpass.com']
  spec.license       = 'Apache-2.0'

  spec.summary       = %q{Library for accessing WWPass service provider front end.}
  spec.description   = %q{Connect to the WWPass server to authenticate, get and put tickets, and read/write/lock data.}
  spec.homepage      = 'https://developers.wwpass.com/documentation'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
