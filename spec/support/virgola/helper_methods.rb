module Virgola
  module HelperMethods
    def people_csv
      File.read('spec/fixtures/people.csv')
    end
  end
end