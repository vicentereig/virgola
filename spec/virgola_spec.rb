require 'spec_helper'

class Task
  include Virgola

  column :title
  column :description

  #belongs_to :developer
end

class Developer
  include Virgola

  column :id
  column :name
  column :email

  has_many :tasks, type: Task

  def initialize
    yield self if block_given?
  end

  def ==(pip)
    return false unless pip.is_a?(Developer)
    self.id == pip.id && self.name == pip.name && self.email == pip.email
  end
end

describe Virgola do
  let(:dev) { Developer.new { |p| p.id = 1; p.name = 'John Snow'; p.email = 'john@snow.com' } }

  it 'should respond to column attribute methods' do
    %w(id name email).each { |field|
      self.dev.should respond_to "#{field}="
      self.dev.should respond_to "#{field}"
      self.dev.should respond_to "#{field}?"
    }
  end

  it 'should respond to has_many attribute methods' do
    self.dev.should respond_to "tasks"
    self.dev.should respond_to "tasks="
    self.dev.should respond_to "tasks?"
    self.dev.should respond_to "tasks<<"
    self.dev.tasks.should == []
  end

  #
  #before :each do
  #  @people  = Developer.parse(people_csv)
  #  @chris   = Developer.new { |p| p.id = "1"; p.name = "Chris Floess";      p.email = "chris@propertybase.com"}
  #  @konsti  = Developer.new { |p| p.id = "2"; p.name = "Konstantin Krauss"; p.email = "konstantin@propertybase.com"}
  #  @vicente = Developer.new { |p| p.id = "3"; p.name = "Vicente Reig";      p.email = "vicente@propertybase.com"}
  #  @expected_pips = [@chris, @konsti, @vicente]
  #
  #end
  #
  #it 'should extract three people' do
  #  @people.should include @chris
  #  @people.should include @konsti
  #  @people.should include @vicente
  #end
  #
  #it 'should allow to override attribute accesors' do
  #  class Developer
  #    def email
  #      "<#{super}>"
  #    end
  #  end
  #
  #  @chris.email.should == "<chris@propertybase.com>"
  #end
  #
  #it 'should allow to access instance attributes' do
  #  class Developer
  #    def email
  #      "<#{@email}>"
  #    end
  #  end
  #
  #  @chris.email.should == "<chris@propertybase.com>"
  #end
end