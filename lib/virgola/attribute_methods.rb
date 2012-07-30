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

      def has_attribute?(name)
        self.attributes.find { |a| a.name == name }
      end

      def attribute(name, options={})
        define_attribute_methods Array.wrap name
        options.reverse_merge!(column: self.attributes.size)
        attribute = Virgola::Attribute.new(name.to_sym, options.delete(:type), options)
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
      self.attribute(name.to_sym).present?
    end

    def get_attribute(name)
      self.attributes.find { |a| a.name == name.to_sym } || self.relationships.find { |r| r.has_attribute?(name)}
    end

    def relationships
      self.attributes.select { |a| a.is_a?(Virgola::Relationships::HasOne) }
    end

    def attributes
      self.class.attributes
    end
  end
end