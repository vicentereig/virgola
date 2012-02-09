require 'virgola'

class Person
  include Virgola::Callbacks

  after_parse :do_something_after_parsing
  after_map   :do_something_after_map_a_row

  def self.parse

  end

  def map

  end

  protected
  def do_something_after_parsing

  end

  def do_something_after_map_a_row

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
    @person.should_receive :do_something_after_parsing
    @person.map
  end
end