module Siblings
  class Journey

    attr_reader :animalito, :locations, :created_at, :finished_at, :open, :id
    
    include Streamable::Journey
    
    def initialize(animalito, locations)
      @animalito = animalito
      @locations = locations
      @created_at = @finished_at = @open = nil
      @id = SecureRandom.uuid
      
      add_observer Streamable::Streamer.new
      
    end
  
    def start
      @created_at = Time.now
      @open = true
    
      changed
      
      notify_observers(self.as_activity)
    
    end
  
    def finish
      @finished_at = Time.now
      @open = false
      
      notify_observers(self.as_activity)
      
    end
  
    def distance
      @locations.first.distance_to(@locations.last)
    end
  
    def go(&block) 
      start
      yield
      finish
    end
  
    def to_param
      @id
    end

  end

end