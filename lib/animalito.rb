class Animalito
  include Observable 
  include Movable
  
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
  
  def wander

    locations = RouteMaker.new(Location.new(current_location.lat, current_location.lon)).compute    
    journey = Journey.new(self, locations)
    do_journey(journey)

  end
  
  def last_journey
    @journeys.last unless @journeys.empty?
  end
  
  def do_journey(journey, pace = nil)
    
    #TODO: Introduce pace (km/h) at some point
    journey.go do 
      journey.locations.each { |loc| move_to(loc) }
    end
  
    @journeys << journey
    
  end
  
  def unleash
    @leashed = false
  end
  
  def to_param
    name
  end
  
end