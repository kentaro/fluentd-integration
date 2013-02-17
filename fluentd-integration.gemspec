# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluentd/integration/version'

Gem::Specification.new do |spec|
  spec.name          = "fluentd-integration"
  spec.version       = Fluentd::Integration::VERSION
  spec.authors       = ["Kentaro Kuribayashi"]
  spec.email         = ["kentarok@gmail.com"]
  spec.description   = %q{Utilities for integration test for Fluentd.}
  spec.summary       = %q{Utilities for integration test for Fluentd.}
  spec.homepage      = "http://github.com/kentaro/fluentd-integration"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 1.9.2'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "glint"
  spec.add_dependency "fluentd"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.12"
end
