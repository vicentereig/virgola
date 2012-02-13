# encoding: UTF-8

require 'csv'

module Virgola
  class CSVParser
    include Virgola::ExtractionMethods

    def initialize(klass, contents)
      @klass = klass
      @contents = contents
    end

    def extract(csv)
      result_set = CSV.parse(csv*"\n")
      result_set.collect { |result_set_row| map(result_set_row) }
    end

    def map(result_set_row)
      mapped_object = @klass.new

      @klass.attributes.each.with_index do |attr, index|
        mapped_object.send "#{attr.name}=", result_set_row[index]
      end
      mapped_object.run_callbacks(:map)
      mapped_object
    end
  end
end