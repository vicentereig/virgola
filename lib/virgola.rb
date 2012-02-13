# encoding: UTF-8
# TODO: split them into smaller requires
require 'active_model'
require 'active_support/all'

require './lib/virgola/version'
require './lib/virgola/attribute_methods'
require './lib/virgola/extraction_methods'
require './lib/virgola/csv_parser'
require './lib/virgola/callbacks'

module Virgola
  extend  ActiveSupport::Concern

  include Virgola::AttributeMethods
  include Virgola::Callbacks
  include Virgola::ExtractionMethods

  module ClassMethods
    def parse(csv)
      @parser ||= CSVParser.new self, csv.strip.split("\n")
    end
  end
end
