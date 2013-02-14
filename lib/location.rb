class Location
  include Observable 
  
  GOOGLE_API_KEY = 'AIzaSyCRHvR0X-DG2ef4tUl84j2lAPOKUG5-w1s'
  
  attr_reader :lat, :lon, :csquare, :geohash, :occupants
  
  def initialize(lat, lon)
    @lat = lat
    @lon = lon
    @csquare = CSquare.new(@lat,@lon)
    @geohash = GeoHash.encode(@lat,@lon)
    @occupants = []

    add_observer Announcer.new
		
  end
  
  def gstreetview_url
"http://maps.googleapis.com/maps/api/streetview?size=400x400&location=#{@lat},#{@lon}&sensor=false&key=#{GOOGLE_API_KEY}"
  end
  
  def add_occupant(occupant)
    @occupants << occupant
    Bump.new(occupants).crash if (@occupants.size > 1)
    notify_observers(self, "#{to_param} has a new visitor #{occupant.to_param}", :new_occupant)		
  end
  
  def remove_occupant(occupant)
    @occupants.delete(occupant)
  end
  
  def to_param 
    geohash
  end
  
end