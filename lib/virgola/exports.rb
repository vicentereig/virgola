# encoding: UTF-8
module Virgola::Exports
  extend ActiveSupport::Concern

  module ClassMethods
    def to_csv(exportables, options={})
      exportables = [exportables] unless exportables.is_a?(Array)
      include_headers = options.delete(:headers)
      output_filename = options.delete(:ouput)
      exportables.map { |exportable|
        headers, row = exportable.export(include_headers)
        materialize(headers, row, output_filename)
      }
    end
  protected
    def materialize(header=nil, row, output_filename)

    end
  end

  def export(include_headers)
    csv = String.new
    CSV(csv) { |out| out << self.to_row }
  end

protected

  def to_row
    self.attributes.collect { |attribute_name| }
  end
end