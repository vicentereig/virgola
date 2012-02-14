# encoding: UTF-8

require 'csv'

module Virgola
  class CSVParser
    def initialize(klass, contents)
      @klass = klass
      @contents = contents
    end

    def extract(csv)
      result_set = CSV.parse(csv*"\n")
      result_set.collect { |result_set_row| map(result_set_row) }
    end

    def map(values)
      mapped_object = @klass.new

      @klass.attributes.each.with_index do |attr, index|
        mapped_object.send("#{attr.name}=", values[index])
      end
      mapped_object.run_callbacks(:map)
      mapped_object
    end
  end
end