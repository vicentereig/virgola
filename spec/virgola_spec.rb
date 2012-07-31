require 'spec_helper'

class CompanyProfile
  include Virgola

  column :email
  column :phone

  belongs_to :developer

  def initialize
    yield self if block_given?
  end

  def ==(profile)
    return false unless profile.is_a?(self.class)
    self.email == profile.email && self.phone == profile.phone
  end
end

class Task
  include Virgola

  column :title
  column :description
  belongs_to :developer

  def initialize
    yield self if block_given?
  end

  def ==(task)
    return false unless task.is_a?(self.class)
    self.title == task.title && self.description == task.description
  end
end

class Developer
  include Virgola

  column :id
  column :name
  column :email

  has_many :tasks,   type: Task
  has_one  :profile, type: CompanyProfile

  def initialize
    yield self if block_given?
  end

  def ==(pip)
    return false unless pip.is_a?(self.class)
    self.id == pip.id && self.name == pip.name && self.email == pip.email
  end
end

describe Virgola do

  let(:dev)     { Developer.new { |p| p.id = 1; p.name = 'John Snow' } }
  let(:task)    { Task.new      { |t| t.title = 'The Title'; t.description = 'The Description'  } }
  let(:profile) { CompanyProfile.new { |c| c.email = 'john@snow.com'; c.phone = 017610101010    } }

  it 'should respond to column attribute methods' do
    %w(id name).each { |field|
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
    self.dev.tasks.should be_empty
  end

  it 'should respond to has_one attribute methods' do
    self.dev.should respond_to "profile"
    self.dev.should respond_to "profile="
    self.dev.should respond_to "profile?"
    self.dev.profile.should be_nil
  end

  it 'should respond to belongs_to attribute methods' do
    self.task.should respond_to "developer"
    self.task.should respond_to "developer?"
    self.task.should respond_to "developer="
    self.task.developer.should be_nil
  end

  it 'should allow initializing has_one relations' do
    self.dev.profile.should be_nil
    self.dev.profile= self.profile
    self.dev.profile.should == self.profile
  end

  it 'should allow adding more children to has_many relation' do
    -> {
      self.dev.tasks << self.task
    }.should change(self.dev.tasks, :size).from(0).to(1)

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