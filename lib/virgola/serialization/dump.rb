module Virgola
  module Serialization
    # http://fastercsv.rubyforge.org/classes/FasterCSV.html#M000008
    module Dump
      extend ActiveSupport::Concern

      module ClassMethods
        def dump(collection, io="", options={})
          CSV.dump(collection, io, options).strip
        end
      end

      # Avoid CSV writing the 'class, Class.to_s' row
      # It will dump a blank line instead which will be removed
      def csv_meta
        []
      end

      # returns an Array of headers which will be serialized
      def csv_headers
        self.attributes.values.map(&:column_names).flatten
      end

      # returns the serialized fields
      def csv_dump(headers)

      end
    end
  end
end