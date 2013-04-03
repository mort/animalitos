module Siblings
  module Data
    
    class Position < ActiveRecord::Base
      
      self.table_name = "positions"
      
      belongs_to :actor, :polymorphic => true
      belongs_to :location

    end
  end
end