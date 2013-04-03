module Siblings
  module Data
    
    class Location < ActiveRecord::Base
      
      self.table_name = "locations"
      
      attr_accessible :lat, :lon, :true_lat, :true_lon, :csquare, :geohash
      
      has_and_belongs_to_many :journeys
      
    end
    
    
  end
end