module Virgola
  module Relation
    module BelongsTo
      extend ActiveSupport::Concern

      module ClassMethods
        def belongs_to(name, options={})
          self.attributes[name.to_s] ||= Virgola::Relation::BelongsTo::Proxy.new(name.to_sym, options)
        end
      end

      class Proxy
        def initialize(name, options)

        end
      end
    end
  end
end