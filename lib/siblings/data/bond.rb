module Siblings
  module Data
    
    class Bond < ActiveRecord::Base
      
      self.table_name = "bonds"

      belongs_to :player
      belongs_to :animalito

    end
    
    
  end
end