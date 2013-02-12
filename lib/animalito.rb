class Animalito
  include Observable 
  include Mobile
  
  attr_accessor :leashed
  attr_reader :player, :name, :paths, :bumps
  
  def initialize
    @positions = []
    @name = SecureRandom.uuid
    @bumps = []
    @paths = []
    
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
    path = imagine_path(current_location.lat, current_location.lon)
  end
  
  
  def imagine_path(lat = 40.4091123, lon = -3.6934069, step = 0.001 , n = 25)
    
    w = []
    
    n.times do |i|
      lat = lat + step
      lon = lon + step
      
      w << Location.new(lat, lon)
      
    end
  end
  
  def unleash
    @leashed = false
  end
  
  def to_param
    name
  end
  
end