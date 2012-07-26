# encoding: UTF-8
# TODO: split them into smaller requires
require 'active_model'
require 'active_support/all'

require 'virgola/version'
require 'virgola/attribute'
require 'virgola/attribute_methods'
require 'virgola/extraction_methods'
require 'virgola/csv_parser'
require 'virgola/callbacks'

module Virgola
  extend  ActiveSupport::Concern
  include Virgola::Exports
  include Virgola::AttributeMethods
  include Virgola::Callbacks

  class CSVParser
    include Virgola::ExtractionMethods
  end

  module ClassMethods
    def parse(csv)
      @parser = CSVParser.new self, csv.strip.split("\n")
    end
  end
end
