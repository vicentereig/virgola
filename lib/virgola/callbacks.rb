# encoding: UTF-8
module Virgola
  module Callbacks
    extend  ActiveSupport::Concern

    include ActiveModel::Callbacks

    included do
      define_model_callbacks :parse, only: [:after] # TODO: parse is a class method, i'll need to define a `define_model_callback`
      define_model_callbacks :map,   only: [:after]
    end

    module ClassMethods

    end

    module InstanceMethods

    end

  end
end