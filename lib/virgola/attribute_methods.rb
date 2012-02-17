# encoding: UTF-8

#
# Overridable accessors as of Nunemaker.
# http://railstips.org/blog/archives/2010/08/29/building-an-object-mapper-override-able-accessors/
#
module Virgola
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
        attribute = Attribute.new(name.to_sym, options.delete(:type), options)
        attributes << attribute unless attributes.include?(attribute)
      end
    end

    def attribute(name)
      instance_variable_get "@#{name}"
    end

    def attribute=(name, value)
      instance_variable_set "@#{name}", value
    end

    def attribute?(name)
      self.attribute(name).present?
    end

    def attributes
      self.class.attributes
    end
  end
end