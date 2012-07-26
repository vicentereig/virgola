# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "virgola/version"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'virgola'
  s.version     = Virgola::VERSION
  s.summary     = 'An attempt to make CSV parsing and mapping suck less.'
  s.description = 'Virgola is a CSV to object mapper.'
  s.files       = Dir.glob("{lib,spec}/**/*") + %w[License Rakefile README.textile]
  s.required_ruby_version     = '>= 1.9.2'
  s.required_rubygems_version = '>= 1.8.11'

  s.author            = 'Vicente Reig Rincón de Arellano'
  s.email             = 'vicente@propertybase.com'
  s.homepage          = 'https://github.com/propertybase/virgola'

  s.add_runtime_dependency('activesupport', '3.1.3')
  s.add_runtime_dependency('activemodel',   '3.1.3')
  s.add_development_dependency('bundler',   '~> 1.0')
  s.add_development_dependency('fakefs')
  s.add_development_dependency('rspec')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end
