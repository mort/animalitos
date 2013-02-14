class Animalito
  include Observable 
  include Mobile
  
  attr_accessor :leashed
  attr_reader :player, :name, :paths, :bumps, :journeys
  
  def initialize
    @positions = []
    @name = SecureRandom.uuid
    @bumps = []
    @paths = []
    @journeys = []
    
		add_observer Announcer.new
    
  end
    
  def bond_with(player)
    @player = player
    @leashed = true
    changed
    notify_observers(self, "#{to_param} is now bonded with #{player.to_param}", :bond)
    
    player
  end
  
  def dream_path
    l = Location.new(current_location.lat, current_location.lon)
    PathMaker.make(l)
  end
  
  def wander 
    locations = dream_path
    journey = Journey.new(self, locations)
    journey.go
    @journeys << journey
  end
  
  def unleash
    @leashed = false
  end
  
  def to_param
    name
  end
  
end

class PathMaker
  
  def initialize(start_location, stop_location = nil, strategy = :linear, step = 0.0001 )
    
    @start_location = start_location
    @stop_location = stop_location || @start_location 
    @strategy = strategy
    @step = step
    
    raise 'Must supply a location' unless (start_location.is_a?(Location) and stop_location.is_a?(Location))
  
  end

  def make
    send("make_#{strategy}", start_location, stop_location, step)
  end
  
  def make_linear(start_location, stop_location, step)
    
    n = 25
    locations = []
    
    n.times do |i|
      lat = lat + step
      lon = lon + step

      locations << Location.new(lat, lon)

    end
    
    locations
    
  end



end

class Journey

  def initialize(animalito, locations)
    @animalito = animalito
    @locations = locations
    @created_at = Time.now
    @finished_at = nil
    @open = true
  end
  
  def go

    @locations.each { |loc| @animalito.move_to(loc) }
    finish

  end
  
  def finish
    @finished_at = Time.now
    @open = false
  end

end




