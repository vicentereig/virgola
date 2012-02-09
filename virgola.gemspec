# encoding: UTF-8
require File.expand_path('../lib/virgola/version' , __FILE__)

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'Virgola'
  s.version     = Virgola::VERSION::STRING
  s.summary     = 'An attempt to make CSV parsing and mapping suck less.'
  s.description = 'Virgola is a CSV to Ruby objects mapper.'

  s.required_ruby_version     = '>= 1.9.2'
  s.required_rubygems_version = '>= 1.8.11'

  s.author            = 'Vicente Reig Rincón de Arellano'
  s.email             = 'vicente.reig@gmail.com'
  s.homepage          = 'http://github.com/vicentereig/virgola'

  s.add_dependency('activesupport', '3.1.3')
  s.add_dependency('activemodel',   '3.1.3')
  s.add_dependency('bundler',       '~> 1.0')
end