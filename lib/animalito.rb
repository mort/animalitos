class Animalito
  include Observable 
  include Movable
  
  attr_reader :player, :name, :paths, :bumps, :journeys, :leashed
  
  def initialize
    @positions = []
    @name = SecureRandom.uuid
    @bumps = []
    @paths = []
    @journeys = []
    @leashed = nil
    
		add_observer Announcer.new

		changed
		
    notify_observers(self, "#{to_param} is born!", :birth)
    
  end
    
  def bond_with(player)

    @player = player
    @leashed = true
    changed
    notify_observers(self, "#{to_param} is now bonded with #{player.to_param}", :bond)
    
    player

  end
  
  def wander

    raise "Don't pull on the leash!" if @leashed
    
    locations = RouteMaker.new(Location.new(current_location.lat, current_location.lon)).compute    
    journey = Journey.new(self, locations)
    do_journey(journey)

  end
  
  def last_journey
    @journeys.last unless @journeys.empty?
  end
  
  # Speed in km/h or nil for "instajourneys"
  def do_journey(journey, speed = nil)
    
    interval = !speed.nil? ? ((journey.length / (speed.to_f / 3600.0)) / locations) : nil
    
    #TODO: Introduce pace (km/h) at some point
    journey.go do 
      journey.locations.each do |loc| 
        move_to(loc) 
        sleep(interval) unless interval.nil?
      end
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