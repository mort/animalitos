class Position
  
  attr_reader :created_at, :animalito, :location, :venue
  
  def initialize(location, animalito, options = {})
    
    @created_at = Time.now
    @animalito = animalito
    @location = location
    @venue = options[:venue]
    
    @location.add_occupant(animalito)
  end
  
end
