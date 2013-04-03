module Siblings
  class Journey

    attr_reader :animalito, :locations, :created_at, :finished_at, :open
    
    include Streamable::Journey
    
    def initialize(animalito, locations)
      @animalito = animalito
      @locations = locations
      @created_at = nil
      @finished_at = nil
      @open = nil
      @uuid = SecureRandom.uuid
      
      add_observer Streamable::Streamer.new
      
    end
  
    def start
      @created_at = Time.now
      @open = true
    
      changed
      
      notify_observers(self.as_activity)
    
      @open
    end
  
    def finish
      @finished_at = Time.now
      @open = false
      
      notify_observers(self.as_activity)
      
      @open
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
      @uuid
    end

  end

end