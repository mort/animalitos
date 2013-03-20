module Siblings

  class Position

    attr_reader :created_at, :actor, :location, :venue, :leashed
    
    include Streamable::Position
    
    def initialize(location, actor, options = {})

      @id = SecureRandom.uuid
      @created_at = Time.now
      @actor = actor
      @location = location
      @venue = options[:venue]
      @leashed = options[:leashed]
      
      @location.add_occupant(actor)

      #CartoDB::Connection.insert_row 'animalitos_positions', :name => @actor.name, :lat => @location.lat, :lon => @location.lon, :description => @actor.class.to_s

    end
    
    def to_s
      @venue ? @venue['name'] : @location.formatted_address
    end
    
    def to_param
      @id
    end
  

  end

end
