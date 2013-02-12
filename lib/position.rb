class Position
  
  attr_reader :created_at, :animalito, :location
  
  def initialize(location, animalito)
    @created_at = Time.now
    @animalito = animalito
    @location = location
    
    @location.add_occupant(animalito)
  end
  
end
