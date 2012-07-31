require 'virgola/relation/has_many'
require 'virgola/relation/has_one'

module Virgola
  module Relation
    extend ActiveSupport::Concern

    include Virgola::Relation::HasOne
    include Virgola::Relation::HasMany
  end
end