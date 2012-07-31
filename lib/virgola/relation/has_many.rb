module Virgola
  module Relation
    module HasMany
      extend ActiveSupport::Concern

      class Collection < Array
        def initialize(proxy, owner, children=[])
          @proxy = proxy
          @owner = owner
          children.each { |child| process_child(child) }
          super(children)
        end

        def <<(child)
          process_child(child)
          super(child)
        end
      protected
        def process_child(child)
          @proxy.target = child
          child.belongs_to!(@proxy.inverse_of, @owner) if child.belongs_to?(@proxy.inverse_of)
        end
      end

      included do
        attribute_method_suffix '', '=', '?'
      end

      module ClassMethods
        def has_many(name, options={})
          self.attributes[name.to_s] ||= Virgola::Relation::HasMany::Proxy.new(name.to_sym, options)
        end
      end

      def attribute(key)
        return super unless proxy(key).is_a?(Virgola::Relation::HasMany::Proxy)
        super || default_initializer(key)
      end

      def proxy(key)
        self.attributes[key]
      end

      def attribute=(key, children)
        return super unless proxy(key).is_a?(Virgola::Relation::HasMany::Proxy)

        children = Collection.new(children, self.proxy(key))

        super(key, children)
      end

      class Proxy
        attr_accessor :target, :inverse_of

        def initialize(name, options=[])
          @name       = name
          @inverse_of = options[:inverse_of]
          @options    = options
        end
      end

    protected
      def default_initializer(key)
        collection = Collection.new(self.proxy(key), self)

        instance_variable_set("@#{key}", collection)
        instance_variable_get("@#{key}")
      end
    end
  end
end