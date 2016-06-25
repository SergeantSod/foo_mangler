# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foo_mangler/version'

Gem::Specification.new do |spec|
  spec.name          = "foo_mangler"
  spec.version       = FooMangler::VERSION
  spec.authors       = ["Johannes Pirkl"]
  spec.email         = ["guess@where.com"]

  spec.summary       = %q{Simple transformation from text input to text output described by a DSL}
  spec.description   = %q{A utility to take an arbitrary input file in a tabular format such as CSV and a configuration in a Ruby DSL that describes what output is to be produced }
  spec.homepage      = "https://github.com/SergeantSod/foo_mangler"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10.3"
end
