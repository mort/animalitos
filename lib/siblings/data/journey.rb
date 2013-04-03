module Siblings
  module Data
    class Journey < ActiveRecord::Base
      
      self.table_name = "journeys"
      
      has_and_belongs_to_many :locations
      
    end
  end
end