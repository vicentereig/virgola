require 'virgola/relation/has_many'
require 'virgola/relation/has_one'
require 'virgola/relation/belongs_to'

module Virgola
  module Relation
    extend ActiveSupport::Concern

    include Virgola::Relation::HasOne
    include Virgola::Relation::HasMany
    include Virgola::Relation::BelongsTo
  end
end