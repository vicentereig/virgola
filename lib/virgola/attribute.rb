class Boolean; end

module Virgola

  Types = [String, Float, Time, Date, DateTime, Integer, Boolean]


  class Attribute
    attr_accessor :name, :type, :value, :options

    def initialize(name,type=String,*args)
      @name    = name
      @type    = type
      @value   = nil
      @options = args.extract_options!
    end

    def map(mapped_object, value)
      mapped_object.send("#{self.name}=", cast(value))
    end

    #
    # Based on <https://github.com/jnunemaker/happymapper/blob/master/lib/happymapper/item.rb#L84>
    #
    def cast(value)
      cast_value =
          case self.type
            when Float    then self.value.to_f
            when Integer  then self.value.to_i
            when Fixnum   then self.value.to_i
            when Time     then Time.parse(self.value)
            when Date     then Date.parse(self.value)
            when DateTime then DateTime.parse(self.value)
            when Boolean  then ['true', 'false', 't', 'f', 'y', 'n', 'yes', 'no'].include?(self.value.to_s.downcase)
            when Integer  then cast_to_integer(self.value.to_s)
            else nil
          end

      cast_value || self.type.cast(value) if self.type.respond_to?(:cast)
    end

    def ==(attribute)
      return false unless attribute.is_a?(Attribute)
      self.name == attribute.name && self.value == attribute.value
    end
  end

end