module Virgola
  module SerializationMethods
    extend ActiveSupport::Concern
    module ClassMethods

      #def parse(csv)
      #  CSV.load(loader_csv(csv))
      #end

      #def csv_load(meta, headers, row)
      #  object = self.new
      #
      #  headers.each.with_index { |header, index|
      #    self.attributes[header]
      #  }
      #
      #  object
      #rescue NoMethodError => error
      #  puts error
      #  puts error.backtrace
      #  exit
      #end

      def dump(collection, io="", options={})
        CSV.dump(collection, io, options).strip
      end
      #
      #def csv_meta
      #  []
      #end

    protected
      def meta
        %W(class #{self.to_s}) *","
      end

      def loader_csv(csv)
        [meta, csv]*"\n"
      end
    end

    def csv_headers
      #self.attributes.map { |attribute|
      #  if attribute.is_a?(Virgola::Relationships::HasOne)
      #    next attribute.type.attributes.map { |attr| [attribute.name, attr.name] * "_" }
      #  elsif attribute.is_a?(Virgola::Relationships::HasMany)
      #    next attribute.type.csv_headers
      #  end
      #  attribute.name
      #}.flatten
    end

    def csv_dump(headers)
      dump_strategy(headers).flatten
    end

    def dump_strategy(headers)
      headers.map.with_index { |header, index|
        attribute = self.find_attribute(header)
        if attribute.is_a?(Virgola::Relationships::HasOne)
          headers = headers[0..index-1] + [header] + headers[index+1..headers.length]
          field_name = header.split(/#{attribute.name}_/).last
          next self.send(attribute.name).csv_dump([field_name])
        else
          next self.attribute(header)
        end
      }.flatten
    end

    def map(header, row, index)
      attribute = self.find_attribute(header)
      if attribute.is_a?(Virgola::Relationships::HasMany)
        attribute.map(self, header, row, index)
      elsif attribute.is_a?(Virgola::Relationships::HasOne)
        attribute.map(self, row, index)
      else
        attribute.map(self, row)
      end
    end

    def find_attribute(name)
      self.attributes.find { |attribute| name =~ /^#{attribute.name.to_s}/ } ||
          self.attributes.find { |attribute| name =~ /^#{attribute.name.to_s.singularize}/ }
    end


  end
end