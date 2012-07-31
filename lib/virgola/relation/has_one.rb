module Virgola
  module Relation
    module HasOne
      extend ActiveSupport::Concern

      module ClassMethods
        def has_one(name, options={})
          self.attributes[name.to_s] ||= Virgola::Relation::HasOne.new(name.to_sym, options)
        end
      end

      class HasOneProxy

      end
    end
  end
end