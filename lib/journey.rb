class Journey

  attr_reader :animalito, :locations, :created_at, :finished_at, :open, :id

  def initialize(animalito, locations)
    @animalito = animalito
    @locations = locations
    @created_at = @finished_at = @open = nil
    @id = SecureRandom.uuid
  end
  
  def start
    @created_at = Time.now
    @open = true
  end
  
  def finish
    @finished_at = Time.now
    @open = false
  end
  
  def distance
    @locations.first.distance_to(@locations.last)
  end
  
  def go(&block) 
    start
    yield
    finish
  end
  
  def to_param
    @id
  end

end
