module Siblings
  module Data
    
    class Feeding < ActiveRecord::Base
      
      self.table_name = "feedings"
      
      belongs_to :animalito

    end
    
    
  end
end