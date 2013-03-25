module Siblings
  module Services
    class Weather
        
      WEATHER_UNDERGROUND_KEY = '42903ef0aeba690e'
      TTL = 300
  
      attr_reader :location, :data, :id
  
      include Streamable::Weather
      
      def initialize(loc)
        
        raise "Need a location" if loc.nil?
        
        @id = SecureRandom.uuid
        @location = loc
        @data = nil
      end

      def endpoint
        "http://api.wunderground.com/api/#{WEATHER_UNDERGROUND_KEY}/conditions/q/#{@location.lat},#{@location.lon}.json"
      end
  
      def [](k)
        @data ||= HTTParty.get(endpoint)
        @data['current_observation'][k]
      end

      def to_param
        @id
      end


    end
  end
end