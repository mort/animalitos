module Siblings
  module Traits
    module Enjoys
  
      JOY_LIMIT = 500
      TIME_BETWEEN_WEATHER_CHECKS = 300
  
      def joy 
        @scores[:joy].value
      end
  
      def enjoy(uri, what, points = 10)

        increment = @temperament.consider(uri) * points
        scores[:joy].change_by(increment)
    
      end
  

      def enjoy_weather(loc = nil)

        loc ||= current_location

        #puts "You can plan a pretty picnic, but you can't predict the weather (#{loc})"

        weather = Services::Weather.new(loc)

        @last_weather_check = Time.now.to_i
        enjoy(weather['current_observation']['icon_url'], :weather) 
    
      end
  
      def time_to_enjoy_the_weather_again?
    
        @last_weather_check ||= Time.now.to_i
        (Time.now.to_i -  @last_weather_check) > TIME_BETWEEN_WEATHER_CHECKS
  
      end
  
  
      def enjoy_venue(venue)
  
        enjoy(venue['canonicalUrl'], :venue)
  
      end
  
      def enjoy_animalito(animalito)
        return false if animalito === self
        enjoy(animalito.to_iri, :animalito)
      end
  

    end
  end
end
