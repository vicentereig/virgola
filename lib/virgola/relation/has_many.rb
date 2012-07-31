module Virgola
  module Relation
    module HasMany
      extend ActiveSupport::Concern

      included do
        attribute_method_suffix '', '=', '?', '<<'
      end

      module ClassMethods
        def has_many(name, options={})
          self.attributes[name.to_s] ||= Virgola::Relation::HasMany::Proxy.new(name.to_sym, options)
        end
      end

      def attribute(key)
        return super unless self.attributes[key].is_a?(Virgola::Relation::HasMany::Proxy)
        super || default_initializer(key)
      end

      class Proxy
        def initialize(name, options)

        end
      end

    protected
      def default_initializer(key)
        instance_variable_set("@#{key}", [])
        instance_variable_get("@#{key}")
      end
    end
  end
end