require 'spec_helper'

class ContactInfo
  include Virgola

  attribute :email, type: String, column: 2
  attribute :phone, type: String, column: 3

  def initialize
    yield self if block_given?
  end

  def ==(pip)
    return false unless pip.is_a?(ContactInfo)
    self.email == pip.email && self.phone == pip.phone
  end
end

class Person
  include Virgola

  attribute :id
  attribute :name
  has_one   :contact_info, type: ContactInfo

  def initialize
    yield self if block_given?
  end

  after_map :do_something_after_map_a_row

  def ==(pip)
    return false unless pip.is_a?(Person)
    self.id == pip.id && self.name == pip.name && self.contact_info == pip.contact_info
  end

protected
  def do_something_after_map_a_row

  end
end


describe Virgola::SerializationMethods do
  context "Parsing HasOne Relationships" do
    before :each do
      @chris   = Person.new { |p| p.id = "1"; p.name = "Chris Floess";      p.contact_info = ContactInfo.new { |c| c.email = "chris@propertybase.com";      c.phone = "123456798" } }
      @konsti  = Person.new { |p| p.id = "2"; p.name = "Konstantin Krauss"; p.contact_info = ContactInfo.new { |c| c.email = "konstantin@propertybase.com"; c.phone = "123456798" } }
      @vicente = Person.new { |p| p.id = "3"; p.name = "Vicente Reig";      p.contact_info = ContactInfo.new { |c| c.email = "vicente@propertybase.com";    c.phone = "123456798" } }
      @expected_pips = [@chris, @konsti, @vicente]
    end

    it 'should succesfully load the has_one relation' do
      Person.parse(people_contact_infos_csv).should == @expected_pips
    end

    it 'should properly dump HasOne grouped columns' do
      Person.dump(Person.parse(people_contact_infos_csv)).should == people_csv
    end
  end
end