class Boolean; end

module Virgola
  module Columns
    extend ActiveSupport::Concern

    module ClassMethods
      def column(name, options={})
        define_attribute_methods [name.to_sym]
        self.attributes[name.to_s] ||= Virgola::Columns::Proxy.new(name.to_sym, options)
      end
    end

    class Proxy
      attr_accessor :name, :type, :index

      def initialize(name,*args)
        @options = args.extract_options!

        @name    = name
        @type    = @options[:type]
        @index   = @options[:index]
      end

      def ==(column)
        return false unless column.is_a?(self.class)
        self.name == column.name
      end

      def <=>(column)
        self.index <=> column.index
      end

      def column_names
        [@name.to_s]
      end

      def prefix
        @prefix ||= @name.to_s
      end
    end
  end
end