module Siblings
  module Repositories
    
    module Animalito
      extend Edr::AR::Repository
      set_model_class Siblings::Animalito

      def self.find_by_name name
        where(name: name)
      end
    end
    
    
  end
end