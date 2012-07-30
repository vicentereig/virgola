module Virgola
  module HelperMethods
    def people_csv
      File.read('spec/fixtures/people.csv')
    end

    def people_contact_infos_csv
      File.read('spec/fixtures/people_contact_infos.csv')
    end


    def people_has_manies_csv
      File.read('spec/fixtures/people_has_manies.csv')
    end
  end
end