module Streamable
  
  module Scuffle
    def as_activity(participant)

      return false unless (@over && @participants.include?(participant))

      the_object = self.as_obj
      the_actor = participant.as_actor
      the_location = @location.as_obj
      verb = @tie ? 'tie' : (participant == @winner) ? 'win' : 'lose'

      activity {
        verb  verb
        actor the_actor
        obj the_object   
        self[:location] = the_location
      }

    end

    def as_obj

      name = "#{@a1.name} vs #{@a2.name}"
      the_id = to_iri

      game { 
        display_name name
        id the_id
      }
    end

    def to_param
      @id
    end

    def to_iri
      "tag:littlesiblings.com,2013:#{self.to_param}"
    end

    
  end


  module Animalito
    
    def to_param
       @id
     end

     def as_actor
       name = @name
       iri = to_iri

       person {
         display_name name
         id iri
       }
     end

     def as_obj
       as_actor
     end

     def as_activity

       a = self.as_actor

       activity {
         verb 'born'
         actor a
       }
     end

     def to_iri
       "tag:littlesiblings.com,2013:#{self.to_param}"
     end
     
  end


  module Location
    def to_iri
      "tag:littlesiblings.com,2013:#{self.to_param}"
    end

    def as_obj

      lat = @lat
      lon = @lon
      #fa = formatted_address
      alt = altitude
      iri = to_iri

      place {
        position  {
          latitude  lat
          longitude lon
          altitude  alt
        }
        id iri
      }    
    end
  end

  module Player
    
    def to_param
      @id
    end

    def to_iri
      "tag:littlesiblings.com,2013:#{self.to_param}"
    end
    
  end
  
  module Bump
  
    def to_param
      @id
    end

    def to_iri
      "tag:littlesiblings.com,2013:#{self.to_param}"
    end

    def as_activity(a1, a2, result) 
      return false unless (@animalitos.include?(a1) && @animalitos.include?(a2))

      the_actor = a1.as_actor
      the_object = a2.as_obj
      the_location = @location.as_obj

      activity {
        verb  'bump'
        actor the_actor
        obj the_object   
        self[:location] = the_location
      }
    end
    
  end

end