require 'active_support/inflections'
require 'active_support/inflector'

module Virgola
  module Relationships
    extend ActiveSupport::Concern

    class Relation < Virgola::Attribute
      attr_accessor :options, :name, :type, :parent
      def initialize(name, type, *args)
        @options = args.extract_options!
        @name    = name
        @type    = type
        @parent  = nil
      end
    end

    class HasOne < Relation

      def initialize(name, type, *args)
        super(name, type, *args)
      end

      def map(parent, row, offset)
        self.parent = parent
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

    class HasMany < Relation
      def initialize(name, type, *args)
        super(name, type, *args)
      end

      def size
        self.parent.send(self.name).size
      end

      def map(parent, header, row, offset)
        debugger
        self.parent = parent
        children = parent.send(self.name)
        if children.blank?

          children = []
          parent.send("#{self.name}=", children)
        end

        _, position, field_name = header.split(/_/)
        position = position.to_i - 1
        child = children[position] || self.type.new
        child.map_from_has_many(field_name,row,offset)
        unless children[position].present?
          children[position] = child if  child.send(field_name).present?
        end
      end


      def has_attribute?(name)
        self.type.has_attribute?(name.to_sym)
      end
    end

    def initialize(*args)
      puts "Callback"
    end

    module ClassMethods
      def has_one(name, options={})
        define_attribute_methods Array.wrap name
        options.reverse_merge!(offset: self.attributes.size)
        attribute = Virgola::Relationships::HasOne.new(name.to_sym, options.delete(:type), options)
        attributes << attribute unless attributes.include?(attribute)
      end

      def has_many(name, options={})
        define_attribute_methods Array.wrap name
        options.reverse_merge!(offset: self.attributes.size)
        attribute = Virgola::Relationships::HasMany.new(name.to_sym, options.delete(:type), options)
        unless attributes.include?(attribute)
          attributes << attribute
        end

      end
    end
  end
end