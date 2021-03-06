module Siblings

  module Streamable
    
    def self.to_iri(o)
      "tag:littlesiblings.com,2013:#{o.to_param}"
    end
    
    def self.activity_id
      uuid = SecureRandom.uuid
      "tag:littlesiblings.com,2013:#{uuid}"
    end
  
    module Scuffle
      
      def as_activity(participant)

        return false unless (@over && @participants.include?(participant))
      
        the_object = self.as_obj
        the_actor = participant.as_actor
        the_location = @location.as_obj
        verb = @tie ? 'tie' : (participant == @winner) ? 'win' : 'lose'
      
        activity {
          id Streamable.activity_id
          verb  verb
          actor the_actor
          obj the_object   
          self[:location] = the_location
        }

      end

      def as_obj

        name = "#{@a1.name} vs #{@a2.name}"
        the_id = Streamable.to_iri(self)

        game { 
          display_name name
          id the_id
        }
      end
    
    end

    module Animalito
    
       CONTENT_STRINGS = {:born => 'is born'}
    
       def as_actor
         name = @name
         iri = Streamable.to_iri(self)

         person {
           display_name name
           id iri
         }
       end

       def as_obj
         as_actor
       end

       def as_activity(v = :born, loc = nil)
         
         a = self.as_actor
         
         p = if @birth_location and (v == :born)
           @birth_location.as_obj 
         elsif loc
           loc.as_obj
         end
         
         s = "#{name} #{CONTENT_STRINGS[v]}" if CONTENT_STRINGS.has_key? v

         activity {
           id Streamable.activity_id
           verb v.to_s
           actor a
           self[:location] = p if p
           published Time.now.xmlschema
           content s  
         }
         
       end

    end

    module Location

      def as_obj

        lat = @lat
        lon = @lon
        #fa = formatted_address
        alt = altitude
        the_iri = Streamable.to_iri(self)

        place {
          position  {
            latitude  lat
            longitude lon
            altitude  alt
          }
          id the_iri
        }    
      end
    end

    module Player
    
      def as_actor 
        name = @name
         iri = Streamable.to_iri(self)

         person {
           display_name name
           id iri
         }
      end
    
    end
  
    module Bump
  
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
          published Time.now.xmlschema
          id Streamable.activity_id
        }
      end
    
    end

    module Position
      
      def as_activity

        act   = @actor.as_actor
        place = self.as_obj
        v = @venue ? :checkin : :at
        s = "#{@actor.name} is at #{self.to_s}"
        
        if @actor.bound? && @actor.leashed
          other_name = @actor.significant_other.name
          s << " with #{other_name}"
        end

        
        activity {
          verb v
          actor act
          obj place
          published Time.now.xmlschema
          id Streamable.activity_id
          content s
        }

      end

      def as_obj
        
          lat = @location.lat
          lon = @location.lon
          alt = @location.altitude
          iri = Streamable.to_iri(self)
          venue_name = @venue.name if @venue

          place {
            position  {
              latitude  lat
              longitude lon
              altitude  alt
            }
            self[:displayName] = venue_name if venue_name
            id iri
          }    
      end
        
      
    end

    module Bond
      
      def as_activity
        
        player = @player.as_actor
        animalito = @animalito.as_actor
        the_location = @player.current_position.as_obj if @player.current_position
        
        activity {
          verb :bond
          actor player
          obj animalito
          self[:location] = the_location if the_location
          published Time.now.xmlschema
          id Streamable.activity_id
        }
        
      end
      
    end

    module Feeding
      
      def as_activity

        animalito = @animalito.as_actor
        
        activity {
          verb 'feed'
          actor animalito
          obj self.as_obj
          id Streamable.activity_id
        }

      end
      
      def as_obj
        
        iri = Streamable.to_iri(self)
        the_url = "http://littesiblings.com/feedings/"
        
        image {
         url the_url
         id the_iri
       }
       
      end
      
    end

    module Journey
      
      def as_activity
        
        return nil if @open.nil?
        
        animalito = @animalito.as_actor
        v = @open ? 'start-journey' : 'end-journey'
        o = self.as_obj
        c = @animalito.name
        c += @open ? ' has gone for a walk' : ' finished a walk'
        
        animalito = @animalito.as_actor
        
         activity {
          actor animalito
          verb v
          published Time.now.xmlschema
          id Streamable.activity_id
          obj o
          content c
         }
         
      end
      
      def as_obj
        
         iri = Streamable.to_iri(self)
        
         object('journey') {
           display_name "Journey"
           id iri
         }
        
      end
      
      
    end
  
    module Liking 
    
      def as_activity 
        
        animalito = @animalito.as_actor
        o = @what.as_obj
        v = (@sign == 1) ? 'likes' : 'dislikes'
        
        c = case @type 
          when 'Siblings::Services::Venue'
            "#{@animalito.name} #{v} being at #{@what.name}"
          when 'Siblings::Services::Weather'
            "The weather is #{@what['weather'].downcase} and #{@animalito.name} #{v} that."
          end        
          
        activity {
          actor animalito
          verb v
          published Time.now.xmlschema
          id Streamable.activity_id
          obj o
          content c
        }
        
      end
    
    end
  
    module Venue
    
      def as_obj
        
        name = self.name
        lat = location['lat']
        lon = location['lng']
        
        place {
          position  {
            latitude  lat
            longitude lon
          }
          displayName name
        }
      end
    
    end
  
    module Weather
   
      def as_obj
        
        iri = Streamable.to_iri(self)

         object('weather') {
           display_name "Weather"
           id iri
         }
        
      end
   
    end
  
  end
end