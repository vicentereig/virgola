# encoding: UTF-8
# TODO: split them into smaller requires
require 'csv'
require 'active_model'
require 'active_support/all'

require 'virgola/version'
require 'virgola/attribute'
require 'virgola/attribute_methods'
require 'virgola/relationships'
require 'virgola/serialization_methods'
require 'virgola/callbacks'

module Virgola
  extend  ActiveSupport::Concern
  include Virgola::SerializationMethods
  include Virgola::AttributeMethods
  include Virgola::Relationships
  include Virgola::Callbacks
end
