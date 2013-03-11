class Bump
  include Observable 
  
  include Streamable::Bump
  
  def initialize(animalitos, location)
    @id = SecureRandom.uuid
    @animalitos = animalitos
    @location = location
    
    add_observer Streamer.new

  end
  
  def crash
    
    @animalitos.each {|a| a.bumps << self }
    
    combos = @animalitos.combination(2).to_a
    
    combos.each do |c|
      
      a1 = c[0]
      a2 = c[1]
      
      # Let's get each sibling's opinion of the other
      o1 = a1.enjoy_animalito(a2)
      o2 = a2.enjoy_animalito(a1)
      
      # If they agree
      if o1 == o2 
        
        bumpers = c.map(&:to_param).join(', ')
        
        # Let's reflect that on their joys
        a1.enjoy_animalito(a2)
        a2.enjoy_animalito(a1)
        
        # If they don't like each other, a quarrel ensues. 
        if o1 == -1
          Scuffle.new([a1,a2], @location).play 
        else
          notify_observers self.as_activity(a1, a2, o1) 
          notify_observers self.as_activity(a2, a1, o1)           
        end

      end
      
       
    end
    

  end
  
  
  
end