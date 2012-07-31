module Virgola
  module Serialization
    # http://fastercsv.rubyforge.org/classes/FasterCSV.html#M000008
    module Dump
      extend ActiveSupport::Concern

      module ClassMethods
        def dump(collection, io="", options={})
          CSV.dump(collection, io, options).strip
        end

        # Avoid CSV writing the 'class, Class.to_s' row
        # It will dump a blank line instead which will be removed
        def csv_meta
          []
        end
      end

      # returns an Array of headers which will be serialized
      def csv_headers
        self.attributes.values.map(&:column_names).flatten
      end

      # returns the serialized fields
      def csv_dump(headers)
        headers.map { |header|
          next column_value(header) if self.proxy(header).is_a?(Virgola::Columns::Proxy)

          proxy = self.proxy_for(header)

          if proxy.is_a?(Virgola::Relation::HasOne::Proxy)
            next has_one_column_value(proxy, header)
          end

          if proxy.is_a?(Virgola::Relation::HasMany::Proxy)
            next has_many_column_value(proxy, header)
          end
        }.flatten.compact
      end

    protected
      def proxy_for(header)
        self.attributes.values.find { |proxy| header =~ /^#{proxy.prefix}/ }
      end

      def column_value(header)
        self.send(header)
      end

      def has_one_column_value(proxy, header)
        self.send(proxy.name).send(field_name(proxy.prefix, header))
      end

      def has_many_column_value(proxy, header)
        index, column_name = field_name_with_index(proxy.prefix, header)
        self.send(proxy.name)[index.to_i].send(column_name)
      end

      def field_name_with_index(prefix, header)
        field_name(prefix, header).split(/(\d+)_(.*)/).reject(&:blank?)
      end

      def field_name(prefix, header)
        header.split(/^#{prefix}_/).reject(&:blank?).first
      end
    end
  end
end