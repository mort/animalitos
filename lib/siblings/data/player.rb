module Siblings
  module Data
    
    class Player < ActiveRecord::Base
      
      self.table_name = "players"
      
      attr_accesible :name, :uuid
      
      has_one :bond
      has_one :player, :through => :bond
      has_many :positions, :as => :actor

    end
    
    
  end
end