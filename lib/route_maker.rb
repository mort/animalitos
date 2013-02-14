class RouteMaker
  
  def initialize(start_location, stop_location = nil, strategy = :linear, step = 0.0001 )

    stop_location ||= start_location
  
    raise 'Must supply a location' unless (start_location.is_a?(Location) and stop_location.is_a?(Location))

    @start_location = start_location
    @stop_location = stop_location  
    @strategy = strategy
    @step = step
    
  end

  def make
    send("make_#{strategy}")
  end
  
  def make_linear
    
    lat = @start_location.lat
    lon = @start_location.lon
    
    n = 25
    locations = []
    
    n.times do |i|
      lat = lat + @step
      lon = lon + @step

      locations << Location.new(lat, lon)

    end
    
    locations
    
  end



end