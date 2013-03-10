class Position

  attr_reader :created_at, :actor, :location, :venue

  def initialize(location, actor, options = {})

    @created_at = Time.now
    @actor = actor
    @location = location
    @venue = options[:venue]

    @location.add_occupant(actor)


    #CartoDB::Connection.insert_row 'animalitos_positions', :name => @actor.name, :lat => @location.lat, :lon => @location.lon, :description => @actor.class.to_s

  end
  
  def as_activity
    
    act   = @actor.as_actor
    place = @location.as_obj
    
    activity {
      verb :at
      actor act
      obj place
      
      published Time.now.xmlschema
    }
        
  end
  
  def as_obj
    @location.as_obj
  end


end
