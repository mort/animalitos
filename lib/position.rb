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



end
