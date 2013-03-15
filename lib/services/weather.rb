class Weather
  
  WEATHER_UNDERGROUND_KEY = '42903ef0aeba690e'
  TTL = 300
  
  attr_reader :location, :weather_data
  
  def initialize(loc)
    
    raise "Need a location" if loc.nil?
    
    @location = loc
    @weather_data = nil
  end

  def endpoint
    "http://api.wunderground.com/api/#{WEATHER_UNDERGROUND_KEY}/conditions/q/#{@location.lat},#{@location.lon}.json"
  end
  
  def [](k)
    @weather_data ||= HTTParty.get(endpoint)
    @weather_data[k]
  end


end