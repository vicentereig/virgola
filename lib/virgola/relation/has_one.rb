module Virgola
  module Relation
    module HasOne
      extend ActiveSupport::Concern

      module ClassMethods
        def has_one(name, options={})
          self.attributes[name.to_s] ||= Virgola::Relation::HasOne::Proxy.new(name.to_sym, options)
        end
      end

      def attribute=(key, child)
        return super unless self.attributes[key].is_a?(Virgola::Relation::HasOne::Proxy)
        proxy        = self.proxy(key)
        proxy.target = child
        child.belongs_to!(proxy.inverse_of, self) if child.belongs_to?(proxy.inverse_of)

        super(key, child) # set the instance variable
      end

      class Proxy
        attr_accessor :target, :inverse_of

        def initialize(name, options=[])
          @name       = name
          @inverse_of = options.delete(:inverse_of)
          @type       = options.delete(:type)
          @options    = options
        end

        def column_names
          @type.attributes.collect { |key, proxy|
            [@name, key]*"_" if proxy.is_a?(Virgola::Columns::Proxy)
          }.compact
        end
      end
    end
  end
end