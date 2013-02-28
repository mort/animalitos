class Player
  include Observable
  include Movable

	attr_accessor :animalito, :name

	def initialize(name)
		@name = name
		@animalito = nil
		@positions = []
    @bound = false

		add_observer Announcer.new
	end

	def hatch
	  return if @bound
        bond_with(Animalito.new)
      end

	def bond_with(animalito)
	  raise 'Already bonded' if @bound

		@animalito = animalito
		@animalito.bond_with(self)
		@bound = true

		# Player should follow its animalito
    #follow(@animalito)

		changed
		notify_observers self, "#{to_param} is now bonded with #{animalito.to_param}", :bond

		animalito
	end

	def unbond
	  @animalito = nil
  end

  def checkin(venue)

    lat = venue.location.lat
    lon = venue.location.lng

    move_to(Location.new(lat,lon), {:checkin => true, :venue => venue})
  end

	def move_to(location, options = {:with_animalito => true})
	  super
	  @animalito.move_to(location, options) if @animalito && options[:with_animalito] && @animalito.leashed
  end

	def to_param
    name
  end

end
