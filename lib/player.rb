class Player
  include Observable
  include Moves

  include Streamable::Player

	attr_reader :name, :bond, :positions, :bound, :inbox

	def initialize(name)

    @id = SecureRandom.uuid
		@name = name
		@bond = nil
		@positions = []
    @bound = false
    
    @inbox = Inbox.new(self)
    
		add_observer Streamer.new
	end
	
	def notify(msg)
    @inbox << msg
  end

  def animalito
    return false unless @bound
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
  end

  def checkin(venue)

    lat = venue.location.lat
    lon = venue.location.lng

    move_to(Location.new(lat,lon), {:checkin => true, :venue => venue})
  end

	def move_to(location, options = {:with_animalito => true})
	  super
	  animalito.move_to(location, options) if animalito && options[:with_animalito] && animalito.leashed
  end

end
