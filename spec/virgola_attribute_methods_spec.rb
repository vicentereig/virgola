require 'virgola'

class Person
  include Virgola

  attribute :id,   match: 'refno'
  attribute :name, match: 'givenname'
end

describe Virgola do

  before :all do
    @person = Person.new
  end

  it 'should respond to the id method' do
    @person.should respond_to :id
  end

end