# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grill/version'

Gem::Specification.new do |gem|
  gem.name          = "grill"
  gem.version       = Grill::VERSION
  gem.authors       = ["uu59"]
  gem.email         = ["k@uu59.org"]
  gem.description   = %q{Implant Gemfile into your script}
  gem.summary       = %q{Implant Gemfile into your script}
  gem.homepage      = "https://github.com/uu59/grill"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "bundler"
  gem.add_development_dependency "rspec"
end
