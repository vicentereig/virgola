module Virgola
  module Relation
    module HasMany
      extend ActiveSupport::Concern

      module ClassMethods
        def has_many(name, options={})
          self.attributes[name.to_s] ||= Virgola::Relation::HasMany.new(name.to_sym, options)
        end
      end

      class HasManyProxy

      end
    end
  end
end