require File.expand_path("../lib/siblings/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'Siblings'
  s.version     = Siblings::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Manuel González Noriega"]
  s.email       = ['manuel.gonzalez.noriega@gmail.com']
  s.homepage    = "http://littlesiblings.com"
  s.summary     = "Siblings"
  s.description = "Little siblings"

  s.required_rubygems_version = ">= 1.3.6"

  # lol - required for validation
  s.rubyforge_project         = "siblings"

  # If you have other dependencies, add them here
  # s.add_dependency "another", "~> 1.2"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "*.md"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  # s.executables = ["newgem"]

  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"
end