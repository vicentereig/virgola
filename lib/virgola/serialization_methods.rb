module Virgola
  module SerializationMethods
    extend ActiveSupport::Concern
    module ClassMethods
      def parse(csv)
        CSV.load(loader_csv(csv))
      end

      def csv_load(meta, headers, row)
        object = self.new
        headers.each.with_index { |header, index|
          object.map(header, row, index)
        }
        object
      end

      def dump(collection)

      end

    protected
      def meta
        %W(class #{self.to_s}) *","
      end

      def loader_csv(csv)
        [meta, csv]*"\n"
      end
    end


    def map(header, row, index)
      attribute = self.get_attribute(header)
      attribute.map(self, row, index)
    end

  end
end