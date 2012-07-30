# encoding: UTF-8

module Virgola
  module AttributeMethods
    extend  ActiveSupport::Concern
    include ActiveModel::AttributeMethods

    included do
      attribute_method_suffix '', '=', '?'
    end

    module ClassMethods
      def attributes
        @attributes ||= {}
      end
    end
  end
end