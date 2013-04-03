module Siblings
  module Data
    
    class Scuffle < ActiveRecord::Base
      
      self.table_name = "scuffles"
      
      attr_accessible :over, :tie
      
      belongs_to :winner
      belongs_to :loser
      belongs_to :location
      belongs_to :a1
      belongs_to :a2
          
      
    end
    
    
  end
end