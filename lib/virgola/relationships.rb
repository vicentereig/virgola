module Virgola
  module Relationships
    extend ActiveSupport::Concern

    class HasOne < Virgola::Attribute
      def initialize(name, type, *args)
        @options = args.extract_options!
        @name = name
        @type = type
      end

      def map(parent, row, offset)

        child = parent.send(self.name) || self.type.new
        child.csv_headers.each { |header|
          child.map(header, row, offset)
        }
        parent.send("#{self.name}=", child)
      end

      def has_attribute?(name)
        self.type.has_attribute?(name.to_sym)
      end
    end

    module ClassMethods
      def has_one(name, options={})
        define_attribute_methods Array.wrap name
        options.reverse_merge!(offset: self.attributes.size)
        attribute = Virgola::Relationships::HasOne.new(name.to_sym, options.delete(:type), options)
        attributes << attribute unless attributes.include?(attribute)
      end
    end
  end
end