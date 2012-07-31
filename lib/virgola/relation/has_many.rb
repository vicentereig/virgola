module Virgola
  module Relation
    module HasMany
      extend ActiveSupport::Concern

      included do
        attribute_method_suffix '', '=', '?', '<<'
      end

      module ClassMethods
        def has_many(name, options={})
          self.attributes[name.to_s] ||= Virgola::Relation::HasMany::HasManyProxy.new(name.to_sym, options)
        end
      end

      def attribute(key)
        instance_variable_get("@#{key}") || []
      end

      class HasManyProxy
        def initialize(name, options)

        end
      end
    end
  end
end