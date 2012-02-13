# encoding: UTF-8

#
# Overridable accessors as of Nunemaker.
# http://railstips.org/blog/archives/2010/08/29/building-an-object-mapper-override-able-accessors/
#
module Virgola

  class Attribute
    attr_accessor :name, :options, :value

    def initialize(name,*args)
      @name    = name
      @value   = nil
      @options = args.extract_options!
    end

    def ==(attribute)
      return false unless attribute.is_a?(Attribute)
      self.name == attribute.name && self.value == attribute.value
    end
  end

  module AttributeMethods
    extend  ActiveSupport::Concern
    include ActiveModel::AttributeMethods

    included do
      attribute_method_suffix '', '=', '?'
    end

    module ClassMethods
      def attributes
        @attributes ||= []
      end

      def attribute(name, options={})
        define_attribute_methods Array.wrap name
        attributes << Attribute.new(name.to_sym, options)
      end
    end

    def attribute(name)
      instance_variable_get "@#{name}"
    end

    def attribute=(name, value)
      instance_variable_set "@#{name}", value
    end

    def attribute?(name)
      binding.pry
      self.attribute(name).present?
    end

    def attributes
      self.class.attributes
    end
  end
end