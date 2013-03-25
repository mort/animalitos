module Siblings
  class Liking
  
    attr_reader :who, :what, :type, :sign
  
    include Streamable::Liking
  
    def initialize(animalito, what, sign)

      @animalito = animalito
      @sign = sign
      @what = what
      @type = @what.class.to_s

    end

  end
end