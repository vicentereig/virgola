require 'rubygems'
require 'bundler/setup'

require 'rspec'
require File.expand_path('../../lib/virgola', __FILE__)


Dir["./spec/support/**/*.rb"].each {|f| require f }

RSpec.configure do |config|
  config.include Virgola::HelperMethods
end
