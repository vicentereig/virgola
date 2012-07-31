require 'spec_helper'

describe Virgola::Serialization::Dump do

  let(:dev)     { Developer.new      { |p| p.id    = 1;               p.name        = 'John Snow'       } }
  let(:task)    { Task.new           { |t| t.title = 'The Title';     t.description = 'The Description' } }
  let(:profile) { CompanyProfile.new { |c| c.email = 'john@snow.com'; c.phone       = "017610101010"      } }

  before :each do
    @developer = self.dev
    @developer.tasks << self.task
    @developer.profile = self.profile
  end

  describe '#csv_headers' do
    it 'should return all column names' do
      @developer.csv_headers.should == %w(id name task_0_title task_0_description profile_email profile_phone)
    end
  end

  describe '#csv_dump' do
    it 'should return a serialized array' do
      expected = [1, 'John Snow', 'The Title', 'The Description', 'john@snow.com', "017610101010"]
      @developer.csv_dump(@developer.csv_headers).should == expected
    end
  end

  it 'should produce CSV' do
    Developer.dump([@developer]).should == developer_csv
  end

end