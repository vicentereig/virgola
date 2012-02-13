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

      #def self.parse_with_callback
      #  self.parse_without_callback
      #  run_callbacks(:parse) { super }
      #end
    end

    def map
      run_callbacks(:map) { super }
    end
  end
end