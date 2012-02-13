# encoding: UTF-8
module Virgola
  module Callbacks
    extend ActiveSupport::Concern

    # ActiveModel::Callbacks is just a Ruby module, not a ActiveSupport::Concern module.
    included do
      extend  ActiveModel::Callbacks
      include ActiveModel::Validations::Callbacks
      define_model_callbacks :parse, only: [:after]
      define_model_callbacks :map,   only: [:after]

    end

    module ClassMethods
      include ActiveModel::Callbacks

      #
      #alias_method_chain :map, :callbacks
      #alias_method_chain :parse, :callbacks

      def self.parse_with_callbacks
        self.parse_without_callbacks
        run_callbacks(:parse) { super }
      end
    end

    def map_with_callbacks
      self.map_without_callbacks
      run_callbacks(:map) { super }
    end
  end
end