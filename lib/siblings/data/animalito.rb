module Siblings
  module Data
    
    class Animalito < ActiveRecord::Base
      
      self.table_name = "animalitos"

      attr_accessible :name, :uuid, :leashed
      
      has_many :positions, :as => :actor
      has_one :bond
      has_one :player, :through => :bon
      has_many :feedings
      has_many :likings
      
      
    end
    
    
  end
end