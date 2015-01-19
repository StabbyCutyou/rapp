# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rapp/version'

Gem::Specification.new do |spec|
  spec.name          = "rapp"
  spec.version       = Rapp::VERSION
  spec.authors       = ["StabbyCutyou"]
  spec.email         = ["sean.kelly@tapjoy.com"]
  spec.summary       = %q{rapp - A gem for building Ruby Apps}
  spec.description   = %q{rapp helps you build native ruby apps with a familiar structure and a handful of familiar conventions.}
  spec.homepage      = "https://github.com/StabbyCutyou/rapp"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1.0"
end
