# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "g5-dbupdate/version"

Gem::Specification.new do |spec|
  spec.name          = "g5-dbupdate"
  spec.version       = G5::DbUpdate::VERSION
  spec.authors       = ["Marc Ignacio"]
  spec.email         = ["padi@users.noreply.github.com"]
  spec.summary       = %q{Update local postgresql db from heroku postresql db}
  spec.description   = %q{Update local postgresql db from heroku postresql db}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["g5-dbupdate"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "commander", "~> 4.3.0"
  spec.add_dependency "heroku"
end
