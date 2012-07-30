require 'spec_helper'

class Dude
  include Virgola

  attribute :id
  attribute :name
  attribute :email

  def initialize
    yield self if block_given?
  end

  after_map :do_something_after_map_a_row

  def ==(pip)
    return false unless pip.is_a?(Dude)
    self.id == pip.id && self.name == pip.name && self.email == pip.email
  end

  protected

  def do_something_after_map_a_row

  end
end

class DudeWithColumnIndexes
  include Virgola
  attribute :email, column: 2
  attribute :id,    column: 0
  attribute :name,  column: 1

  def ==(pip)
    return false unless pip.is_a?(Dude)
    self.id == pip.id && self.name == pip.name && self.email == pip.email
  end
end

describe Virgola::SerializationMethods do

  before :each do
    @people  = Dude.parse(people_csv)
    @chris   = Dude.new { |p| p.id = "1"; p.name = "Chris Floess";      p.email = "chris@propertybase.com"}
    @konsti  = Dude.new { |p| p.id = "2"; p.name = "Konstantin Krauss"; p.email = "konstantin@propertybase.com"}
    @vicente = Dude.new { |p| p.id = "3"; p.name = "Vicente Reig";      p.email = "vicente@propertybase.com"}
    @expected_pips = [@chris, @konsti, @vicente]
  end

  it 'should map object attributes regardless the order they were defined' do
    DudeWithColumnIndexes.parse(people_csv).should == @expected_pips
  end
end