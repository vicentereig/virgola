require 'spec_helper'

class Developer
  include Virgola

  attribute :id
  attribute :name
  attribute :email

  def initialize
    yield self if block_given?
  end

  after_map :do_something_after_map_a_row

  def ==(pip)
    return false unless pip.is_a?(Developer)
    self.id == pip.id && self.name == pip.name && self.email == pip.email
  end

  protected

  def do_something_after_map_a_row

  end
end

describe Virgola do

  before :each do
    @people  = Developer.parse(people_csv)
    @chris   = Developer.new { |p| p.id = "1"; p.name = "Chris Floess";      p.email = "chris@propertybase.com"}
    @konsti  = Developer.new { |p| p.id = "2"; p.name = "Konstantin Krauss"; p.email = "konstantin@propertybase.com"}
    @vicente = Developer.new { |p| p.id = "3"; p.name = "Vicente Reig";      p.email = "vicente@propertybase.com"}
    @expected_pips = [@chris, @konsti, @vicente]

  end

  it 'should extract three people' do
    @people.should include @chris
    @people.should include @konsti
    @people.should include @vicente
  end

  it 'should allow to override attribute accesors' do
    class Developer
      def email
        "<#{super}>"
      end
    end

    @chris.email.should == "<chris@propertybase.com>"
  end

  it 'should allow to access instance attributes' do
    class Developer
      def email
        "<#{@email}>"
      end
    end

    @chris.email.should == "<chris@propertybase.com>"
  end
end