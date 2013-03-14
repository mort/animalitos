class Player
  include Celluloid
  
  include Observable
  include Moves
  
  include Foursquare

  include Streamable::Player

	attr_reader :name, :bond, :positions, :bound, :inbox, :timer, :latest_venue_id

	def initialize(name)

    @id = SecureRandom.uuid
		@name = name
		@bond = nil
		@positions = []
    @bound = false
    @latest_venue_id = nil
    
    @inbox = Inbox.new(self)
    
		add_observer Streamer.new
		
		@timer = after(90) { checkin! }
    
	end
	
	def notify(msg)
    @inbox << msg
  end

  def animalito
    return nil unless @bound
    @bond.animalito 
  end

	def hatch
	  return if @bound
    bond_with(Animalito.new(:location => current_location))
  end

	def bond_with(animalito)
	  raise 'Already bonded' if @bound

    @bond = Bond.new(self, animalito)
		animalito.share_bond(@bond)
		@bound = true

		# Player should follow its animalito
    #follow(@animalito)

		changed
		#notify_observers @bond.as_activity('player')

		animalito
	end
	

	def unbond
	  @bond = nil
	  @bound = false
  end
  
  def checkin!
    puts "Checking in ..."
    checkin(latest_venue) unless @latest_venue_id == latest_venue['id']
    @latest_venue_id = latest_venue['id']
    @timer.reset
  end

  def checkin(venue)

    lat = venue['location']['lat']
    lon = venue['location']['lng']
    loc = Location.new(lat,lon)

    move_to(loc, {:checkin => true, :venue => venue})

  end

	def move_to(location, options)
	  
	  options[:with_animalito] ||= true
	  
	  super
	  animalito.move_to(location, options) if animalito && options[:with_animalito] && animalito.leashed
  end

end
