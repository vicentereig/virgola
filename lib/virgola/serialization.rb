require 'virgola/serialization/dump'

module Virgola
  module Serialization
    extend ActiveSupport::Concern

    include Virgola::Serialization::Dump
  end
end