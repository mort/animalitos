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
  
  def do_journey(pace = nil)
    
    # Just a note to remember to introduce pace at some point

    journey.start
    journey.locations.each { |loc| move_to(loc) }
    journey.finish
    
    @journeys << journey
    
  end
  
  def wander
    locations = RouteMaker.make(Location.new(current_location.lat, current_location.lon))    
    do_journey(Journey.new(self, locations))
  end
  
  def unleash
    @leashed = false
  end
  
  def to_param
    name
  end
  
end