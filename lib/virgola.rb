# encoding: UTF-8
# TODO: split them into smaller requires
require 'active_model'
require 'active_support/all'

require './lib/virgola/version'
require './lib/virgola/attribute_methods'
require './lib/virgola/callbacks'

module Virgola
  extend  ActiveSupport::Concern
  # include Virgola::Mapper
  include Virgola::AttributeMethods
  include Virgola::Callbacks
  # include Virgola::ExtractionMethods


end
