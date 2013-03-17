module Siblings
  class Temperament
  
    attr_reader :p, :likings
  
    def initialize
          
      # TODO: Use something from the player as seed
      prng = Random.new(Time.now.to_i)
      
      like = prng.rand(0.75)
      dislike = prng.rand(like)
      
      @p = {:like => prng.rand , :dislike => prng.rand, :volatile => prng.rand(0.3)}
      @likings = {}
      
    end
  
    def consider(uri)

      thing = uri        
      # Shall we reconsider?
      volatile_p = rand
      
      return @likings[thing] if (@likings.has_key?(thing) && (volatile_p < @p[:volatile]))

      p_like = rand
      p_dislike = rand
      
      @likings[thing] = if p_like < @p[:like] 
                    1
                  elsif p_dislike < @p[:dislike]
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
end