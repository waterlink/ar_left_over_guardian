# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ar_left_over_guardian/version'

Gem::Specification.new do |spec|
  spec.name          = "ar_left_over_guardian"
  spec.version       = ARLeftOverGuardian::VERSION
  spec.authors       = ["Alexey Fedorov"]
  spec.email         = ["waterlink000@gmail.com"]
  spec.summary       = %q{Active Record Left Over Guardian.}
  spec.description   = %q{Active Record Left Over Guardian. Meant to be run after each test. Fails your test suite, if test doesn't clean up any database records after itself. Assumes all your models are descendants of ActiveRecord::Base}
  spec.homepage      = "https://github.com/waterlink/ar_left_over_guardian"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "contracts-noop"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
