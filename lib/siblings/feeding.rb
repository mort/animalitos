module Siblings

  class Feeding

    include Streamable::Feeding

    def initialize(animalito, img)
      @animalito = animalito
      @img = Image.new(img)
      @luma_value = nil
      @uuid = SecureRandom.uuid
    end
  
    def feed
      @luma_value ||= Luma.new(@img.src).to_i 
      increment = @luma_value
    
      @luma_value = @luma_value / 2
    
      increment
    end


    def to_param
      @uuid
    end


  end

end