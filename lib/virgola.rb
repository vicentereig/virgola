# encoding: UTF-8
require 'csv'
require 'active_model'
require 'active_support/all'

require 'virgola/version'
require 'virgola/attribute_methods'
require 'virgola/columns'
require 'virgola/relation'
require 'virgola/serialization'
require 'virgola/type_casting'

module Virgola
  extend  ActiveSupport::Concern

  include Virgola::AttributeMethods
  include Virgola::Columns
  include Virgola::Relation
  include Virgola::Serialization
  include Virgola::TypeCasting

  #include Virgola::Callbacks

end
