module Virgola
  module SerializationMethods
    extend ActiveSupport::Concern
    module ClassMethods

      def offset(offset)
        @offset = offset
        self
      end

      def parse(csv)
        CSV.load(loader_csv(csv))
      end

      def csv_load(meta, headers, row)
        @offset ||= 0
        object = self.new

        headers.each.with_index { |header, index|
          object.map(header, row, index) if index >= @offset
        }

        object
      rescue NoMethodError => error
        puts error
        puts error.backtrace
        exit
      end

      def dump(collection, io="", options={})
        CSV.dump(collection, io, options).strip
      end

      def csv_meta
        []
      end

    protected
      def meta
        %W(class #{self.to_s}) *","
      end

      def loader_csv(csv)
        [meta, csv]*"\n"
      end
    end

    def csv_headers
      self.attributes.map { |attribute|
        if attribute.is_a?(Virgola::Relationships::HasOne)
          next attribute.type.attributes.map { |attr| {attribute.name => attr.name} }
        end
        attribute.name
      }.flatten
    end

    def csv_dump(headers)
      dump_strategy(headers).flatten
    end

    def dump_strategy(headers)
      headers.map.with_index { |header, index|
        if header.is_a?(Hash)
          relation_name = header.keys.first
          relation_headers = header.values.map { |name| [relation_name, name]*"_" }
          result = self.send(relation_name).csv_dump(relation_headers)
          headers = headers[0..index] + relation_headers + headers[index+1..headers.length]
        else
          result = self.attribute(header)
        end
        result
        column_set = header.is_a?(Hash) ? self.send(relation_name).csv_dump(relation_headers) : self.attribute(header)
        headers[index] = header
        column_set
      }.flatten
    end

    def map(header, row, index)
      attribute = self.find_attribute(header)
      attribute.map(self, row, index)
    end

    def find_attribute(name)
      self.attributes.find { |attribute| name =~ /^#{attribute.name.to_s}/ }
    end


  end
end