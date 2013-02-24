class Route
  require 'csv'
  
  STRATEGIES = [:linear, :random_in_bbox, :clockwise_in_bbox]
  
  attr_reader :start_location, :end_location, :strategy, :step, :id, :locations
  
  def initialize(start_location, end_location = nil, strategy = :linear, step = 0.0001)

    end_location ||= start_location
  
    raise 'Must supply a location' unless (start_location.is_a?(Location) and end_location.is_a?(Location))
    raise 'Unknown strategy' unless STRATEGIES.include?(strategy)
    
    @id = SecureRandom.uuid
    @start_location = start_location
    @end_location = end_location  
    @strategy = strategy
    @step = step
    @locations = nil
    
  end

  def compute(*args)
    @locations = send("compute_#{strategy}", args)
  end
  
  def compute_linear(points = 25)
    
    lat = @start_location.lat
    lon = @start_location.lon
    
    locations = []
    
    points.times do |i|
      lat = lat + @step
      lon = lon + @step

      locations << Location.new(lat, lon)

    end
    
    n.times do |i|
      lat = lat - @step
      lon = lon - @step

      locations << Location.new(lat, lon)

    end
    
    locations
    
  end
  
  def compute_random_in_bbox(points = 25, radius = 5)
    
    lat = @start_location.lat
    lon = @start_location.lon
    
    bbox = @start_location.bounding_box(radius)
    
    locations = []
    
    points.times do |i|
          
      lat_ = range(bbox[0],bbox[2])
      lon_ = range(bbox[1],bbox[3])
      d = @start_location.distance_to(Location.new(lat_,lon_)).to_i
      raise "Boom #{lat_}, #{lon_} (d #{d}, r #{radius})" if d > radius*2
      locations << Location.new(lat_,lon_)

    end
    
   locations
    
  end
  
  def compute_clockwise_in_bbox(points = 25, radius = 5)

    locations = compute_random_in_bbox(points, radius)
    
    upper = locations.upperleft
    
    locations.sort! do |a,b|
      return 1 if a == upper 
      return -1 if b == upper
      
      m1 = upper.slope(a)
      m2 = upper.slope(b)
      
      if m1 == m2
        return (a.distance_to(upper) < b.distance_to(upper)) ? 1 : -1  
      end
      
      return -1 if (m1 <= 0 && m2 > 0) 
      
      # If 'p1' is to the left of 'upper' and 'p2' is the the right.
      return 1 if (m1 > 0 && m2 <= 0) 

      # It seems that both slopes are either positive, or negative.
      return (m1 > m2) ? -1 : 1
      
    end
    
    sorted_locations
    
  end
  

    
  def to_csv
    return false if @locations.nil?
    
    p = "/Users/manuelnoriega/Documents/#{id}.csv"
    
    CSV.open(p, "w") do |csv|
      csv << ['lat','lon']
      @locations.each { |l| csv << [l.lat,l.lon] }
    end
     
  end
  
  def range (min, max)
    rand * (max-min) + min
  end

end

class Array
  
  def upperleft
    
    top = self.first
    
    self.each do |loc|
      top = loc if loc.lat > top.lat || (loc.lat == top.lat && loc.lon < top.lon)
    end
    
    top
  
  end

end