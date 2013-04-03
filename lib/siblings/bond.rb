module Siblings

  # The link without player and animalito
  class Bond
  
    attr_reader :player, :animalito, :created_at
    
    include Streamable::Bond
    
    def initialize(player, animalito)
      @animalito = animalito
      @player = player
      @created_at = Time.now
    end

  end
end