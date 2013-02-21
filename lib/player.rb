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
		
		changed    
		notify_observers self, "#{to_param} is now bonded with #{animalito.to_param}", :bond
		
		animalito
	end
	
	def unbond
	  @animalito = nil
  end
	
	def move_to(location)
	  super
	  @animalito.move_to(location) if @animalito.leashed
  end
	
	def to_param
    name
  end
	
end