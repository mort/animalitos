class Route
  require 'csv'
  
  STRATEGIES = [:linear, :random_in_bbox, :clockwise_in_bbox]
  
  attr_reader :start_location, :end_location, :step, :id, :locations
  
  attr_accessor :strategy
  
  def initialize(start_location, end_location = nil, strategy = :linear, step = 0.0001)
  
    raise 'Must supply a location' unless (start_location.is_a?(Location))
    raise 'Unknown strategy' unless STRATEGIES.include?(strategy)
    
    @id = SecureRandom.uuid
    @start_location = start_location
    @end_location = end_location  
    @strategy = strategy
    @step = step
    @locations = nil
    
  end

  def compute(options = {})
    @locations = send("compute_#{strategy}", options)
    @locations << @end_location if @end_location
    @locations
  end
  
  def compute_linear(options = {})
    
    options[:points] ||= 25
    
    points = options[:points]
    
    lat = @start_location.lat
    lon = @start_location.lon
    
    locations = []
    
    points.times do |i|
      lat = lat + @step
      lon = lon + @step

      locations << Location.new(lat, lon)

    end
    
    points.times do |i|
      lat = lat - @step
      lon = lon - @step

      locations << Location.new(lat, lon)

    end
    
    locations
    
  end
  
  def compute_random_in_bbox(options = {})
    
    options[:points] ||= 25
    options[:radius] ||= 5
    
    points = options[:points]
    radius = options[:radius]
    
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
  
  def compute_clockwise_in_bbox(options = {})

    locations = compute_random_in_bbox(options)
    locations.sort_clockwise!

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
  
  def sort_clockwise! 
    upper = self.upperleft
    sort! { |a,b| a.send('<=>', b, upper) }
  end

end