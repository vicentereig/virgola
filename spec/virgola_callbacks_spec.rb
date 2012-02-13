require 'rubygems'
require 'virgola'

class Person
  include Virgola::Callbacks

  after_parse :do_something_after_parsing
  after_map   :do_something_after_map_a_row

  def self.parse
    puts "hello parsing"
    true
  end

  def map
    puts "hello mapping"
    true
  end

  protected
  def do_something_after_parsing
    puts "after parsing"
    return true
  end

  def do_something_after_map_a_row
    puts "after maopping"
    return true
  end
end

describe Virgola do

  before :all do
    @person = Person.new
  end

  it 'should process callbacks after parsing' do
    Person.should_receive :do_something_after_parsing
    Person.parse
  end

  it 'should process callbacks after mapping' do
    binding.pry

    @person.should_receive :do_something_after_map_a_row
    @person.map
  end
end