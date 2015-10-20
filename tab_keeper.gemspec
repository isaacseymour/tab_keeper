# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tab_keeper/version'

Gem::Specification.new do |spec|
  spec.name          = "tab_keeper"
  spec.version       = TabKeeper::VERSION
  spec.authors       = ["Isaac Seymour"]
  spec.email         = ["i.seymour@oxon.org"]

  spec.summary       = %q{Manage crons}
  spec.homepage      = "https://github.com/isaacseymour/tab_keeper"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rspec",   "~> 3"
  spec.add_development_dependency "pry",     "~> 0"
end
