module Siblings

  module Expanded
    
      GOOGLE_API_KEY = 'AIzaSyCRHvR0X-DG2ef4tUl84j2lAPOKUG5-w1s'
    
      def gstreetview_url
        "http://maps.googleapis.com/maps/api/streetview?size=400x400&location=#{@lat},#{@lon}&sensor=false&key=#{GOOGLE_API_KEY}"
      end

      def gmgeocoding_url
        "http://maps.googleapis.com/maps/api/geocode/json?latlng=#{lat},#{lon}&sensor=false"
      end
    
      def gaddress
        @address_data ||=  HTTParty.get(gmgeocoding_url)
        @address_data['results']
      end
    
      def formatted_address
        begin
          gaddress[0]['formatted_address']
        rescue
          "somewhere over the rainbow"
        end
      end
    
  
  end

  module Geo 
  
    def bounding_box(r = 1)
      Geocoder::Calculations.bounding_box([@lat, @lon], r)
    end
  
    def distance_to(l2)
      Geocoder::Calculations.distance_between([@lat, @lon], [l2.lat, l2.lon])
    end
  
    def slope(l2)
      dLat = l2.lat - @lat
      dLon = l2.lon - @lon
    
      dLat / dLon
      
    end
  
    def <=>(b, upper)
    
      return -1 if self == upper 
      return 1 if b == upper
      
      m1 = upper.slope(self)
      m2 = upper.slope(b)
    
      if m1 == m2
        return (self.distance_to(upper) < b.distance_to(upper)) ? 1 : -1  
      end
    
      return -1 if (m1 <= 0 && m2 > 0) 
    
      # If 'p1' is to the left of 'upper' and 'p2' is the the right.
      return 1 if (m1 > 0 && m2 <= 0) 

      # It seems that both slopes are either positive, or negative.
      return (m1 > m2) ? -1 : 1
    end
  
  end

  class Location
    include Observable 
    include Expanded
    include Geo
    include Geocoder
  
    include Streamable::Location
  
    attr_reader :lat, :lon, :altitude, :csquare, :geohash, :occupants, :true_lat, :true_lon
  
    def initialize(lat, lon, altitude = 100, precision = 4)
    
      @true_lat = lat
      @true_lon = lon
      
      @precision = precision
    
      # Precision of 4 decimals ~= 11.1 meters
      # http://en.wikipedia.org/wiki/Decimal_degrees
      @lat = lat.precision(@precision)
      @lon = lon.precision(@precision)
      @altitude = altitude
      @csquare = CSquare.new(@lat,@lon)
      @geohash = GeoHash.encode(@lat,@lon, @precision)
      @occupants = []

      add_observer Streamable::Streamer.new
		
    end
  
    def add_occupant(occupant)
    
      # Ocuppants shall follow the location and nearby locations
      # occupant.follow(self, :nearby => true)
    
      # Only animalitos are relevant for now

      return unless occupant.is_a?(Animalito)

      @occupants << occupant 
      Bump.new(occupants, self).crash if (@occupants.size > 1)
    end
  
    def remove_occupant(occupant)
      @occupants.delete(occupant)
    end
  
    def to_param 
      geohash
    end
  
  end

end


