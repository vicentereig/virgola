require 'rubygems'
require 'pry'
require 'virgola'

class Person
  include Virgola::AttributeMethods

  attribute :id,   match: 'refno'
  attribute :name, match: 'givenname'
end

describe Virgola do

  before :all do
    @person = Person.new
  end

  it 'should respond to the id method' do
    @person.should respond_to :id
    @person.should respond_to :name
  end

end