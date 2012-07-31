module Virgola
  module TypeCasting
    extend ActiveSupport::Concern
    #
    # Based on <https://github.com/jnunemaker/happymapper/blob/master/lib/happymapper/item.rb#L84>
    #
    TYPES = [String, Float, Time, Date, DateTime, Integer, Boolean]

    def cast(type, value)
      case type
        when Float    then value.to_f
        when Time     then Time.parse(value)
        when Date     then Date.parse(value)
        when DateTime then DateTime.parse(value)
        when Boolean  then ['true', 't'].include?(value.to_s.downcase)
        when Integer  then
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

    def attribute=(key, value)
      type  = self.proxy(key).type
      value = cast(type, value) if type.in?(TYPES)
      super(key, value)
    end
  end
end