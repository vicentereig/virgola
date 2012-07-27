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

        next attribute.value.csv_headers if attribute.is_a?(Virgola::Relationships::HasOne)
        attribute.name
      }.flatten
    end

    def csv_dump(headers)
      headers.map { |h| self.attribute(h) }
    end

    def map(header, row, index)
      attribute = self.get_attribute(header)
      attribute.map(self, row, index)
    end

  end
end