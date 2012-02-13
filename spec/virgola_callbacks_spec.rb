require 'rubygems'
require 'virgola'

module DummyMapper
  extend ActiveSupport::Concern

  module ClassMethods
    def parse(csv)
      puts "hello parsing"
      run_callbacks(:parse) { super }
    end
  end

  def map
    true
  end
end

class Person
  include Virgola::Callbacks, DummyMapper

  after_parse :do_something_after_parsing
  after_map   :do_something_after_map_a_row

  protected
  def do_something_after_parsing
    puts "after parsing"
  end

  def do_something_after_map_a_row
    true
  end
end

describe Virgola do

  before :all do
    @person = Person.new
  end

  it 'should process callbacks after parsing' do
    Person.should_receive :do_something_after_parsing

    Person.parse("csv contents")
  end

  it 'should process callbacks after mapping' do
    @person.should_receive :do_something_after_map_a_row

    @person.map
  end
end