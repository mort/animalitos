class RouteMaker
  
  STRATEGIES = [:linear]
  
  attr_reader :start_location, :end_location, :strategy, :step
  
  def initialize(start_location, end_location = nil, strategy = :linear, step = 0.0001)

    end_location ||= start_location
  
    raise 'Must supply a location' unless (start_location.is_a?(Location) and end_location.is_a?(Location))
    raise 'Unknown strategy' unless STRATEGIES.include?(strategy)
    
    @start_location = start_location
    @end_location = end_location  
    @strategy = strategy
    @step = step
    
    
  end

  def compute
    send("compute_#{strategy}")
  end
  
  def compute_linear(n = 25)
    
    lat = @start_location.lat
    lon = @start_location.lon
    
    locations = []
    
    n.times do |i|
      lat = lat + @step
      lon = lon + @step

      locations << Location.new(lat, lon)

    end
    
    locations
    
  end



end