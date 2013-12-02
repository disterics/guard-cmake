# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/cmake/version'

Gem::Specification.new do |spec|
  spec.name          = "guard-cmake"
  spec.version       = Guard::CMakeVersion::VERSION
  spec.authors       = ["disterics"]
  spec.email         = ["disterics@wojeshun.net"]
  spec.description   = %q{Guard::CMake automatically rebuilds c|c++ files when a modification occurs using cmake.}
  spec.summary       = %q{Guard plugin for CMake}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'guard',     '~> 2.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "ruby_gntp"
  spec.add_development_dependency "fakefs"

end
