module Siblings
  module Data
    
    class Liking < ActiveRecord::Base
      
      self.table_name = "likings"
      
      attr_accessible :liking_type, :sign, :uri
      
      belongs_to :animalito

    end
    
    
  end
end