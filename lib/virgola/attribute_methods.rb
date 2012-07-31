# encoding: UTF-8

module Virgola
  module AttributeMethods
    extend  ActiveSupport::Concern
    include ActiveModel::AttributeMethods

    included do
      attribute_method_suffix '', '=', '?'
    end

    module ClassMethods
      def attributes
        @attributes ||= {}
      end
    protected

      def build_attribute(name, value)
        return unless self.attributes.key?(name.to_s)
        self.attributes[name].build(value)
      end
    end

    def proxy(key)
      self.attributes[key]
    end

    def attribute(key)
      instance_variable_get "@#{key}"
    end

    def attribute=(key, value)
      instance_variable_set "@#{key}", value
    end

    def attribute?(key)
      instance_variable_defined? "@#{key}"
    end

    def attributes
      self.class.attributes
    end
  end
end