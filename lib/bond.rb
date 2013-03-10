class Bond
  
  attr_reader :player, :animalito, :created_at
  
  def initialize(player, animalito)
    @animalito = animalito
    @player = player
    @created_at = Time.now
  end

end