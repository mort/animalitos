module Temperament
  
  JOY_LIMIT = 500
  
  def set_temperament
    # TODO: Use something from the player as seed
    prng = Random.new(@created_at.to_i)
    
    like = prng.rand(0.75)
    dislike = prng.rand(like)
    
    {:like => prng.rand , :dislike => prng.rand}
    
  end
  
  def enjoy(uri, points = 10)

    increment = consider(uri) * points
    
    new_joy = @joy + increment
    
    @joy = (new_joy < JOY_LIMIT) ? (new_joy > 0 ? new_joy : 0) : JOY_LIMIT
    
  end
  
  def consider(uri)
    
    # All things have an uri
    thing = uri
    
    return @likings[thing] if @likings.has_key?(thing)
    
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
end