require 'spec_helper'

class PersonWithoutCasting
  include Virgola

  attribute :id    #  defaults to String
  attribute :name  #  defaults to String
  attribute :email #  defaults to String

  def initialize
    yield self if block_given?
  end

  after_map :do_something_after_map_a_row

  def ==(pip)
    return false unless pip.is_a?(Person)
    self.id == pip.id && self.name == pip.name && self.email == pip.email
  end

  protected

  def do_something_after_map_a_row

  end
end

class Person
  include Virgola

  attribute :id,    type: Integer
  attribute :name,  type: String # although it defaults to String
  attribute :email, type: String

  def initialize
    yield self if block_given?
  end

  after_map :do_something_after_map_a_row

  def ==(pip)
    return false unless pip.is_a?(Person)
    self.id == pip.id && self.name == pip.name && self.email == pip.email
  end

  protected

  def do_something_after_map_a_row

  end
end

describe Virgola::Attribute do

  before :each do
    @chris   = Person.new { |p| p.id = 1; p.name = "Chris Floess";      p.email = "chris@propertybase.com"}
    @konsti  = Person.new { |p| p.id = 2; p.name = "Konstantin Krauss"; p.email = "konstantin@propertybase.com"}
    @vicente = Person.new { |p| p.id = 3; p.name = "Vicente Reig";      p.email = "vicente@propertybase.com"}
    @expected_pips = [@chris, @konsti, @vicente]
  end

  it 'should match us' do
    Person.parse(people_csv).should == @expected_pips
  end


end