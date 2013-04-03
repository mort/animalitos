# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'siblings/version'

Gem::Specification.new do |gem|
  gem.name          = "siblings"
  gem.version       = Siblings::VERSION
  gem.authors       = ["Manuel González Noriega"]
  gem.email         = ["manuel.gonzalez.noriega@gmail.com"]
  gem.description   = ""
  gem.summary       = ""
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  #gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency "turn", "~> 0.9.6"
  gem.add_development_dependency "pry", "~> 0.9.12"
  gem.add_development_dependency "minitest", "~> 4.6.2"
  gem.add_development_dependency "minitest-spec-context", "~> 0.0.3"
  gem.add_development_dependency "m", "~> 1.3.1"

  gem.add_dependency "redis", "~> 3.0.2"
  gem.add_dependency "csquares", "~> 0.1.0"
  gem.add_dependency "streams", "~> 0.1.2"
  gem.add_dependency "rufus-mnemo", "~> 1.2.3"
  gem.add_dependency "celluloid", "~> 0.12.4"
  #gem.add_dependency "cartodb-rb-client", "~> 0.4.3"
  gem.add_dependency "httparty", "~> 0.10.2"
  gem.add_dependency "addressable", "~> 2.3.3"
  gem.add_dependency "streams", "~> 0.1.2"
  gem.add_dependency "cocaine", "~> 0.5.1"
  gem.add_dependency "pry", "~> 0.9.12"
  gem.add_dependency "quimby", "~> 0.4.5"
  gem.add_dependency "geocoder", "~> 1.1.6"
  gem.add_dependency "geokit", "~> 1.6.5"
  gem.add_dependency "rgeo", "~> 0.3.20"
  gem.add_dependency "edr", "~> 0.0.5"
  gem.add_dependency "activerecord", "~> 3.2.13"
  gem.add_dependency "mysql2", "~> 0.3.11"
  gem.add_dependency "standalone_migrations", "~> 2.0.6"
  gem.add_dependency "activesupport", "~> 3.2.13"
  
end
