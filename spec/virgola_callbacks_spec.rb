require 'spec_helper'

module DummyMapper
  extend ActiveSupport::Concern

  module ClassMethods
    def parse(csv)
      true
    end
  end

  def map
    true
  end
end

class Person
  include Virgola::Callbacks, DummyMapper

  after_map :do_something_after_map_a_row

  protected

  def do_something_after_map_a_row
    true
  end
end

describe Virgola do

  before :all do
    @person = Person.new
  end

  it 'should process callbacks after mapping' do
    @person.should_receive :do_something_after_map_a_row
    @person.run_callbacks(:map)
  end
end