module Temperament
  
  JOY_LIMIT = 500
  TIME_BETWEEN_WEATHER_CHECKS = 300
  
  def set_temperament
    # TODO: Use something from the player as seed
    prng = Random.new(@created_at.to_i)
    
    like = prng.rand(0.75)
    dislike = prng.rand(like)
    
    {:like => prng.rand , :dislike => prng.rand, :volatile => prng.rand(0.3)}
    
    
    
  end
  
  def enjoy(uri, points = 10)

    increment = consider(uri) * points
    
    new_joy = @joy + increment
    
    @joy = (new_joy < JOY_LIMIT) ? (new_joy > 0 ? new_joy : 0) : JOY_LIMIT
    
    puts "Joy of #{name} is now #{@joy}"
    
  end
  
  def consider(uri)
    puts 'Considering '+uri
    # All things have an uri
    thing = uri
    
    # Shall we reconsider?
    volatile_p = rand
    
    return @likings[thing] if (@likings.has_key?(thing) && (volatile_p > @temperament[:volatile]))

    p_like = rand
    p_dislike = rand
    
    @likings[thing] = if p_like < @temperament[:like] 
                  1
                elsif p_dislike < @temperament[:dislike]
                  -1
                else
                  0
                end 
    
    
  end
  
  def reconsider(thing)
    @likings.delete(thing)
    consider(thing)
  end
  
  
  def enjoy_weather(loc = nil)

    loc ||= current_location

    puts "You can plan a pretty picnic, but you can't predict the weather (#{loc})"

    weather = Weather.new(loc)

    @last_weather_check = Time.now.to_i
    # You can plan a pretty picnic, but you can't predict the weather
    enjoy(weather['current_observation']['icon_url']) 
    
  end
  
  def time_to_enjoy_the_weather_again?
    
    @last_weather_check ||= Time.now.to_i
    (Time.now.to_i -  @last_weather_check) > TIME_BETWEEN_WEATHER_CHECKS
  
  end
  
  
  def enjoy_venue(venue)
  
    enjoy(venue.canonicalUrl)
  
  end
  
end