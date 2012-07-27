class Boolean; end

module Virgola

  Types = [String, Float, Time, Date, DateTime, Integer, Boolean]


  class Attribute
    attr_accessor :name, :type, :column, :options

    def initialize(name,type=String,*args)
      @name    = name
      @type    = type
      @value   = nil
      @options = args.extract_options!
      @column  = options.delete(:column)
    end

    def map(parent, row, index)
      #index = options[:column] if options[:column].present?
      parent.send("#{self.name}=", cast(row[self.column]))
    end

    def ==(attribute)
      return false unless attribute.is_a?(Attribute)
      self.name == attribute.name
    end

    def <=>(attribute)
      self.column <=> attribute.column
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