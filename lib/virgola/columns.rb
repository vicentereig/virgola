class Boolean; end

module Virgola
  module Columns
    extend ActiveSupport::Concern

    module ClassMethods
      def column(name, options={})
        options.reverse_merge!(column: self.attributes.size)
        debugger
        define_attribute_methods [name.to_sym]
        self.attributes[name.to_s] ||= Virgola::Columns::ColumnProxy.new(name.to_sym, options)
      end
    end

    Types = [String, Float, Time, Date, DateTime, Integer, Boolean]

    class ColumnProxy
      attr_accessor :name, :type, :index

      def initialize(name,*args)
        @options = args.extract_options!

        @name    = name
        @type    = @options[:type]
        @index   = @options[:index]
      end

      def ==(attribute)
        return false unless column.is_a?(self.class)
        self.name == column.name
      end

      def <=>(column)
        self.index <=> column.index
      end

      def build(value)

      end

      #
      # Based on <https://github.com/jnunemaker/happymapper/blob/master/lib/happymapper/item.rb#L84>
      #
      def cast(value)
        if    self.type == Float    then value.to_f
        elsif self.type == Time     then Time.parse(value)
        elsif self.type == Date     then Date.parse(value)
        elsif self.type == DateTime then DateTime.parse(value)
        elsif self.type == Boolean  then ['true', 't'].include?(value.to_s.downcase)
        elsif self.type == Integer  then
          # ganked from happymapper :)
          value_to_i = value.to_i
          if value_to_i == 0 && value != '0'
            value_to_s = value.to_s
            begin
              Integer(value_to_s =~ /^(\d+)/ ? $1 : value_to_s)
            rescue ArgumentError
              nil
            end
          else
            value_to_i
          end
        else
          value
        end
      rescue
        value
      end
    end
  end
end