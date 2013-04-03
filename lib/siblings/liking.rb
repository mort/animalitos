module Siblings
  class Liking
  
    attr_reader :animalito, :what, :liking_type, :sign, :uri
  
    include Streamable::Liking
  
    def initialize(animalito, what, sign)

      @animalito = animalito
      @sign = sign
      @what = what
      @liking_type = @what.class.to_s
      @uri = set_uri
    end
    
    
    private
    
      def set_uri
        
        begin
          uri = case @what.class
                when Siblings::Services::Weather
                  @what['current_observation']['icon_url']
                when Siblings::Services::Venue
                  @what.canonicalUrl
                when Animalito
                  Siblings::Streamable.to_iri(@what)  
                else
                  Siblings::Streamable.to_iri(@what)  
                end
        rescue
          rescue "No URI"          
        end
      
        uri
      
      end
  

  end
end