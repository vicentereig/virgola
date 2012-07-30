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

class Picture
  include Virgola

  attribute :title
  attribute :url

  def initialize
    yield self if block_given?
  end

  def ==(pic)
    return false unless pic.is_a?(Picture)
    self.title == pic.title && self.url == pic.url
  end
end

class DudeWithPictures
  include Virgola

  attribute :id
  attribute :name
  has_one   :contact_info, type: ContactInfo
  has_many  :pictures,     type: Picture

  def initialize
    yield self if block_given?
  end

  after_map :do_something_after_map_a_row

  def ==(pip)
    return false unless pip.is_a?(DudeWithPictures)
    self.id == pip.id && self.name == pip.name &&
        self.contact_info == pip.contact_info &&
          self.pictures == pip.pictures
  end

  protected
  def do_something_after_map_a_row

  end
end


describe Virgola::SerializationMethods do
  context "Loading and Dumping HasMany Relationships" do
    before :each do
      @chris   = DudeWithPictures.new { |p| p.id = "1"; p.name = "Chris Floess";      p.contact_info = ContactInfo.new { |c| c.email = "chris@propertybase.com";      c.phone = "123456798" } }
      @konsti  = DudeWithPictures.new { |p| p.id = "2"; p.name = "Konstantin Krauss"; p.contact_info = ContactInfo.new { |c| c.email = "konstantin@propertybase.com"; c.phone = "123456798" } }
      @vicente = DudeWithPictures.new { |p| p.id = "3"; p.name = "Vicente Reig";      p.contact_info = ContactInfo.new { |c| c.email = "vicente@propertybase.com";    c.phone = "123456798" } }
      @expected_pips = [@chris, @konsti, @vicente]


      @pictures = [ Picture.new { |p| p.title = "Title #1"; p.url = "http://domain.com/1.jpg" },
                   Picture.new { |p| p.title = "Title #2"; p.url = "http://domain.com/2.jpg" },
                   Picture.new { |p| p.title = "Title #3"; p.url = "http://domain.com/3.jpg" } ]

      @pictures.each { |p| @chris.pictures ||= [];  @chris.pictures << p }
    end

    it 'should succesfully load the has_many relation' do
      pips = DudeWithPictures.parse(people_has_manies_csv)
      pips.size.should == @expected_pips.size
      pips.first.pictures.size.should == @expected_pips.size
      debugger
      pips.should == @expected_pips
    end

    it 'should dump successfully CSV from an object collection' do
      DudeWithPictures.parse(DudeWithPictures.dump(@expected_pips)).should == @expected_pips
    end

    it 'should properly dump HasMany grouped columns' do
      DudeWithPictures.dump(DudeWithPictures.parse(people_has_manies_csv)).should == people_has_manies_csv
    end
  end

  context "Loading and Dumping HasOne Relationships" do
    before :each do
      @chris   = Person.new { |p| p.id = "1"; p.name = "Chris Floess";      p.contact_info = ContactInfo.new { |c| c.email = "chris@propertybase.com";      c.phone = "123456798" } }
      @konsti  = Person.new { |p| p.id = "2"; p.name = "Konstantin Krauss"; p.contact_info = ContactInfo.new { |c| c.email = "konstantin@propertybase.com"; c.phone = "123456798" } }
      @vicente = Person.new { |p| p.id = "3"; p.name = "Vicente Reig";      p.contact_info = ContactInfo.new { |c| c.email = "vicente@propertybase.com";    c.phone = "123456798" } }
      @expected_pips = [@chris, @konsti, @vicente]
    end

    it 'should succesfully load the has_one relation' do
      pips = Person.parse(people_contact_infos_csv)
      pips.should == @expected_pips
    end

    it 'should dump successfully CSV from an object collection' do
      Person.parse(Person.dump(@expected_pips)).should == @expected_pips
    end

    it 'should properly dump HasOne grouped columns' do
      Person.dump(Person.parse(people_contact_infos_csv)).should == people_contact_infos_csv
    end

  end
end