module Siblings
  
  class Animalito
  
    include Observable
  
    include Traits::Moves
    include Traits::Enjoys
    include Traits::Feeds
    include Traits::Talent
  
    include Streamable::Animalito
    
    attr_reader :bond, :name, :paths, :bumps, :journeys, :scores, :id, :temperament, :bound, :created_at, :birth_location, :likings
    attr_accessor :leashed, :scuffles
  
    def initialize(options = {})
        
      @positions = []
      @id = SecureRandom.uuid
      @name = set_name
      @bumps = []
      @paths = []
      @journeys = []
      @leashed = nil
      @created_at = Time.now
      @bond = nil
      @bound = false
      @birth_location = options.delete(:location)

      @temperament = Temperament.new
      @likings = {}
    
      @scuffles = {:won => [], :lost => []}

      @scores = {:joy => Score.new(100, 0, JOY_LIMIT), :luma => Score.new(100, 0, LUMA_LIMIT)}
    
      @inbox = []
    
      add_observer ::Streamable::Streamer.new

      changed

      notify_observers(self.as_activity)

    end
  
    def player
      return false unless @bound
      @bond.player
    end

    def share_bond(bond)

      @bond = bond
      @bound = true
      @leashed = true
    
      if player.current_location
        action {
        
           options = {}
       
           if player.current_position.venue
            options[:checkin] = true
            options[:venue] = player.current_position.venue
           end
       
           move_to(player.current_location, options) 
        } 
      end

      # Animalito should follow its player
      #follow(@player)

      changed
      #notify_observers(@bond.as_activity('animalito'))

      player

    end

    def action(&blk) 
      raise "Sleeping" if sleeping?
      yield
    end

    def move_to(location, options = {})
      super
      action { enjoy_venue(options[:venue]) } if (options[:checkin] && options[:venue])
      action { enjoy_weather } if time_to_enjoy_the_weather_again?
    end

    def wander(options = {})

      options[:route] ||= {}
      options[:journey] ||= {}

      raise "Don't pull on the leash!" if @leashed

      route = Route.new(current_location)
      locations = route.compute(options[:route])
      journey = Journey.new(self, locations)
      do_journey(journey, options[:journey])

    end
  
    def last_journey
      @journeys.last unless @journeys.empty?
    end

    # Speed in km/h or nil for "instajourneys"
    def do_journey(journey, options = {})
      speed = options[:speed]
      roundtrip = options[:roundtrip]

      # Roundtrip
      journey.locations << journey.locations.first if roundtrip

      last_loc = nil

      journey.go do
        journey.locations.each do |loc|

          # Natural time
          sleep(set_pace(loc, last_loc, speed)) if speed && last_loc
          move_to(loc)

          last_loc = loc

        end
      end


      @journeys << journey
    end

    def unleash
      @leashed = false
    end

    def tick
      consume_luma
    end

    private

    def set_pace(loc, last_loc, speed)
      d = loc.distance_to(last_loc).to_i
      p = d / (speed.to_f / 3600.0)
      #puts "Wasting #{p} seconds (#{(p/3600).to_f} hrs.) on going a distance of #{d}km at a speed of #{speed}/h"
      #p
    end

    def set_name
      i = Time.now.to_i
      i = i*-1 if (i%2 > 0)
      Rufus::Mnemo.from_integer(i)
    end



  end
end
