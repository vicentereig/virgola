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

CSV_INPUT = <<-CSV
id,name,email
1,"Chris Floess",chris@propertybase.com
2,"Konstantin Krauss",konstantin@propertybase.com
3,"Vicente Reig",vicente@propertybase.com
CSV

describe Virgola do

  before :each do
    @person_parser = Person.parse(CSV_INPUT)
    @chris   = Person.new { |p| p.id = "1"; p.name = "Chris Floess";      p.email = "chris@propertybase.com"}
    @konsti  = Person.new { |p| p.id = "2"; p.name = "Konstantin Krauss"; p.email = "konstantin@propertybase.com"}
    @vicente = Person.new { |p| p.id = "3"; p.name = "Vicente Reig";      p.email = "vicente@propertybase.com"}
    @expected_pips = [@chris, @konsti, @vicente]
  end

  it 'should count three people' do
    @person_parser.count.should == 3
  end

  it 'should extract three people' do
    people = @person_parser.all
    people.should include @chris
    people.should include @konsti
    people.should include @vicente
  end

  it 'should extract three people in three iterations' do
    @person_parser.each { |person|
      @expected_pips.should include person
    }
  end

  it 'should extract three people in three batches' do
    @person_parser.in_groups_of(1) { |group|
      @expected_pips.should include group.first
    }
  end
end