class Animalito
  include Observable
  include Movable
  include Temperament

  attr_reader :player, :name, :paths, :bumps, :journeys,  :id, :temperament
  attr_accessor :leashed

  def initialize
    @positions = []
    @id = SecureRandom.uuid
    @name = set_name
    @bumps = []
    @paths = []
    @journeys = []
    @leashed = nil
    @created_at = Time.now

    @temperament = set_temperament
    @likings = {}

    @happiness = 100


    add_observer Announcer.new

    changed

    notify_observers(self, "#{to_param} is born!", :birth)

  end

  def bond_with(player)

    @player = player
    @leashed = true

    # Animalito should follow its player
    #follow(@player)

    changed
    notify_observers(self, "#{to_param} is now bonded with #{player.to_param}", :bond)

    player

  end

  def move_to(location, options = {})
    super
    consider(options[:venue].canonicalUrl) if (options[:checkin] && options[:venue])
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

  def leash
    @leashed = true
  end

  def unleash
    @leashed = false
  end

  def to_param
    id
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
