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
  include Virgola::AttributeMethods
  include Virgola::Callbacks

  module ClassMethods
    def create(attributes={})
      self.new { |o|
        attributes.each { |name, value|
          build_attribute(name, value)
        }
      }
    end

  protected
    def build_attribute(name, value)
      if self.relations.include?(name)
        self.relations[name].build(value)
      else
        self.attributes[name].build(value)
      end
    end
  end
end
