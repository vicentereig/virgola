require 'spec_helper'

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
      self.dev.tasks << self.task
      self.dev.tasks << self.task
    }.should change(self.dev.tasks, :size).from(0).to(3)
  end

  it 'should initialize a has_one back-reference at the belongs_to side' do
    self.dev.profile.should be_nil
    self.dev.profile= self.profile
    self.profile.developer.should == self.dev
  end

  it 'should initialize a has_many back-reference at the belongs_to side' do
    self.dev.tasks << self.task
    self.dev.tasks << self.task
    self.dev.tasks << self.task

    self.dev.tasks.each { |t| t.developer.should == self.dev }
  end
end