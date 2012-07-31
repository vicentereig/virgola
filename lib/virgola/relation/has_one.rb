module Virgola
  module Relation
    module HasOne
      extend ActiveSupport::Concern

      module ClassMethods
        def has_one(name, options={})
          self.attributes[name.to_s] ||= Virgola::Relation::HasOne::Proxy.new(name.to_sym, options)
        end
      end

      def proxy(key)
        self.attributes[key]
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
          @name = name
          @inverse_of = options[:inverse_of]
          @options = options
        end
      end
    end
  end
end