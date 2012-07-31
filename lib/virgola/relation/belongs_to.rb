module Virgola
  module Relation
    module BelongsTo
      extend ActiveSupport::Concern

      module ClassMethods
        def belongs_to(name, options={})
          self.attributes[name.to_s] ||= Virgola::Relation::BelongsTo::Proxy.new(name.to_sym, options)
        end
      end

      def proxy(key)
        self.attributes[key]
      end

      def belongs_to?(association_name)
        self.proxy(association_name).is_a?(Virgola::Relation::BelongsTo::Proxy)
      end

      def belongs_to!(association_name, parent)
        self.send "attribute=", association_name, parent
      end

      class Proxy
        attr_accessor :target, :inverse_of, :type

        def initialize(name, options)
          @name       = name
          @options    = options
          @inverse_of = options[:inverse_of]
        end

        def target?
          self.target.present?
        end

      end
    end
  end
end