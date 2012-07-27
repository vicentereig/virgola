require 'spec_helper'

class Person
  include Virgola

  attribute :id
  attribute :name
  attribute :email

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

class PersonWithColumns
  include Virgola
  attribute :email, column: 2
  attribute :id,    column: 0
  attribute :name,  column: 1

  def ==(pip)
    return false unless pip.is_a?(Person)
    self.id == pip.id && self.name == pip.name && self.email == pip.email
  end
end

CSV_INPUT = <<-CSV
id,name,email
1,Chris Floess,chris@propertybase.com
2,Konstantin Krauss,konstantin@propertybase.com
3,Vicente Reig,vicente@propertybase.com
CSV

describe Virgola::SerializationMethods do

  before :all do
    @people  = Person.parse(CSV_INPUT)
    @chris   = Person.new { |p| p.id = "1"; p.name = "Chris Floess";      p.email = "chris@propertybase.com"}
    @konsti  = Person.new { |p| p.id = "2"; p.name = "Konstantin Krauss"; p.email = "konstantin@propertybase.com"}
    @vicente = Person.new { |p| p.id = "3"; p.name = "Vicente Reig";      p.email = "vicente@propertybase.com"}
    @expected_pips = [@chris, @konsti, @vicente]
  end

  it 'should dump successfully CSV from an object collection' do
    Person.parse(Person.dump(@people)).should == @people
  end

  it 'should map object attributes regardless the order they were defined' do
    PersonWithColumns.parse(CSV_INPUT).should == @expected_pips
  end
end