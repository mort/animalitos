require 'pry'

require 'minitest/spec'
require 'minitest/autorun' 
require 'minitest-spec-context'

require '../animals.rb'

Dir[File.dirname(__FILE__) + '../lib/*.rb'].each {|file| require file }

class TestPlayer < MiniTest::Unit::TestCase

  describe Player do 
    
    before do
      @player = Player.new('mort')
    end
    
    it 'has a name' do
      @player.name.must_equal 'mort'
    end
    
    it 'has to bond with animalitos' do
      a = Animalito.new
      @player.bond_with(a)
      @player.animalito.must_be_same_as a
    end
    
    
    it 'has to share the bond the animalito when bonding' do
      a = Animalito.new
      @player.bond_with(a)
      a.player.must_be_same_as @player
    end
    
    context 'moving' do

       before do
         @l = Location.new(40.4091123, -3.6934069999999997)
         @player.enter_location(@l)
       end

       it 'has to create a new position' do
         @player.positions.size.must_equal 1
       end

       it 'has to have the right current location' do
         @player.current_location.must_equal @l
       end
       
     end





  end

end 
 
class TestAnimalito < MiniTest::Unit::TestCase
  
  describe Animalito do
  
    before do
      @animalito = Animalito.new
    end
    
    it 'has a name' do
      @animalito.name.wont_be_empty
    end
    
    it 'has to bond with players' do
      p = Player.new('mort')
      p.bond_with(@animalito)
      @animalito.player.must_be_same_as p
    end
    
    it 'has to have a birth location when hatched by a player' do
      p = Player.new('mort')
      l = Location.new(40.4091123, -3.6934069999999997)
      p.move_to(l)
      animalito = p.hatch
      animalito.birth_location.must_be_same_as l
    end
    
    it 'has to move to the players location after hatched' do
      p = Player.new('mort')
      l = Location.new(40.4091123, -3.6934069999999997)
      p.move_to(l)
      animalito = p.hatch
      animalito.current_location.must_be_same_as p.current_location
    end
    
    it 'has to go with the player when leashed' do
      p = Player.new('mort')
      l =  Location.new(40.4091123, -3.6934069999999997)
      p.bond_with(@animalito)
    
      p.move_to(l)
      @animalito.current_location.must_be_same_as l
    end
    
    context 'moves' do
      
      before do
        @l = Location.new(40.4091123, -3.6934069999999997)
        @animalito.enter_location(@l)
      end
      
      it 'has to create a new position' do
        @animalito.positions.size.must_equal 1
      end
      
      it 'has to have the right current location' do
        @animalito.current_location.must_equal @l
      end
      
      it 'will bump' do
        animalito2 = Animalito.new
        animalito2.enter_location(@animalito.current_location)
        @animalito.bumps.count.must_equal 1
        @animalito.bumps.first.must_be_instance_of Bump
      end
      
      it 'will wander' do
        @animalito.wander
        @animalito.journeys.wont_be_empty
        @animalito.last_journey.must_be_instance_of Journey
        @animalito.last_journey.open.must_be :===, false
      end 
      
      it 'will go back to the player after wandering if roundtrip specified' do
        player = Player.new('wadus')
        player.bond_with(@animalito)
        player.move_to(@l)
        @animalito.leashed = false
        @animalito.wander(:journey => {:roundtrip => true})
        @animalito.current_location.must_equal @animalito.player.current_location
      end
      
      it 'wont go back to the player after wandering if no roundtrip specified' do
        player = Player.new('wadus')
        player.bond_with(@animalito)
        player.move_to(@l)
        @animalito.leashed = false
        @animalito.wander(:journey => {:roundtrip => false})
        @animalito.current_location.wont_equal @animalito.player.current_location
      end
      
       
                  
    end
    
    context 'enjoys' do
      
    end
  
    context 'feeds' do
      
      it 'should know the percentage of luma' do
        @animalito.luma_percentage.must_equal 20
      end
      
      it 'should notify the player if bound and on a warn level' do
        p = Player.new('mort')
        p.bond_with(@animalito)
        @animalito.consume_luma(50)
        p.inbox.count.must_equal 1
        p.inbox.first[:type].must_equal :luma_level

      end
    
    
    end
  
  
  end
  
end

class TestLocation < MiniTest::Unit::TestCase 

  describe Location do
  
    before do
      @location = Location.new(40.4091123, -3.6934069999999997)
    end
    
    it 'has to store occupants when they enter the location' do
      @animalito = Animalito.new
      @animalito.enter_location(@location)
      @location.occupants.first.must_equal @animalito
    end
    
    it 'has to remove occupants when they leave the location' do
      @animalito = Animalito.new
      @animalito.enter_location(Location.new(40.4491123, -3.6434069999999997))
      @location.occupants.first.wont_equal @animalito
    end
    
  
  end

end

class TestRoute < MiniTest::Unit::TestCase  
  
  describe Route do
  
    before do
      @l1 = Location.new(40.4091123, -3.6934069999999997)
      @l2 = Location.new(40.4091200, -3.6934100000200002)

      @rm = Route.new(@l1, @l2)
    end
    
    it 'has to be valid' do
      @rm.must_be_instance_of Route
    end
    
    it 'has to have start/end locations' do
      
      @rm.start_location.must_be :===, @l1
      @rm.end_location.must_be :===, @l2
      
    end
  
    it 'has to call the default computing method for strategy' do
      @rm.compute
      assert_send [@rm, :compute_linear]
    end
  
    it 'has to compute an array of locations (linear)' do
      locations = @rm.compute
      locations.must_be_instance_of Array
      locations.size.must_be :>, 1
      locations.first.must_be_instance_of Location
      locations.last.must_be_instance_of Location
    end
    
    it 'has to compute an array of locations (random bbox)' do
      strategy = :random_in_bbox
      locations = @rm.compute(:strategy => strategy)
      locations.must_be_instance_of Array
      locations.size.must_be :>, 1
      locations.first.must_be_instance_of Location
      locations.last.must_be_instance_of Location
    end
    
    it 'has to compute an array of locations (clockwise bbox)' do
      strategy = :clockwise_in_bbox
      locations = @rm.compute(:strategy => strategy)
      locations.must_be_instance_of Array
      locations.size.must_be :>, 1
      locations.first.must_be_instance_of Location
      locations.last.must_be_instance_of Location
    end
    
    it 'has to order elements of an array clockwise' do
      # Testing the array extensions based on 
      # http://stackoverflow.com/questions/2855189/sort-latitude-and-longitude-coordinates-into-clockwise-ordered-quadrilateral
      
      sorted = "Hamburg,Praha,Stuttgart,Paris,Bremen,Calais,Rotterdam,Amsterdam".split(',') 
      ordered_points = []
      
      points = {
          "Stuttgart" => [48.7771, 9.1807],
          "Rotterdam" => [51.9226, 4.4707],
          "Paris" => [48.8566, 2.3509],
          "Hamburg" => [53.5538, 9.9915],
          "Praha" => [50.0878, 14.4204],
          "Amsterdam" => [52.3738, 4.8909],
          "Bremen" => [53.0749, 8.8070],
          "Calais" => [50.9580, 1.8524],
      }
      
      
      locations = points.values.map {|p| Location.new(p[0],p[1]) }
      locations.sort_clockwise!
                  
      upper_coords = [locations.upperleft.lat, locations.upperleft.lon]       
            
      locations.each do |l|
        ordered_points << points.key([l.lat,l.lon]) 
      end
      
      upper_coords.must_equal points["Hamburg"]
      ordered_points.must_equal sorted

    end
    
  
    
  end
  
  
end

class TestJourney < MiniTest::Unit::TestCase 
  
  describe Journey do
    
    before do
      l1 = Location.new(40.4091123, -3.6934069999999997)
      l2 = Location.new(40.4091200, -3.6934100000200002)

      rm = Route.new(l1, l2)
      @locations = rm.compute
      @a = Animalito.new
      
      @j = Journey.new(@a, @locations)
    end
    
    it 'has an animalito' do
      @j.animalito.must_be_same_as @a
    end
  
    it 'has locations' do
      @j.locations.must_be_same_as @locations
    end
    
    it 'can be started' do
      @j.start 
      @j.created_at.must_be_kind_of Time
      @j.open.must_be :==, true
    end
    
    it 'can be finished' do
      @j.start
      @j.finish 
      @j.finished_at.must_be_kind_of Time
      @j.open.must_be :==, false  
    end
    
  
    
  end


end

class TestScuffle < MiniTest::Unit::TestCase 

  describe Scuffle do
    
      before do
        @a1 = Animalito.new
        @a2 = Animalito.new
        @l  = Location.new(0.0, 0.0)
        @s = Scuffle.new([@a1,@a2], @l)
      end
      
      it 'should be a scuffle' do
        @s.must_be_instance_of Scuffle
      end
      
      it 'shouldnt be over (til its over)' do
        @s.over.must_equal false
      end
      
      it 'should have participants' do
        [@s.a1, @s.a2].must_equal [@a1, @a2]
      end
      
      it 'should have a location' do
       @s.location.must_equal @l
      end
      
      it 'should end in a tie for animalitos with the same luma' do
        @s.play
        @s.is_a_tie?.must_equal true
        @s.winner.must_equal nil
        @s.loser.must_equal nil
        @s.over.must_equal true
      end
       
    end
  
  describe Scuffle, 'win' do

     before do
       @a1 = Animalito.new
       @a2 = Animalito.new
       # Less luma
       @a2.tick
       @l  = Location.new(0.0, 0.0)
       @s = Scuffle.new([@a1,@a2], @l)
       @s.play
     end

     it 'should end in a win for the animalito with more luma' do
       @s.is_a_tie?.must_equal false
       @s.winner.must_equal @a1
       @s.loser.must_equal @a2
       @s.over.must_equal true
     end
     
     it 'should add to the animalitos scuffles list' do
       @a1.scuffles[:lost].size.must_equal 0
       @a2.scuffles[:lost].size.must_equal 1
       
       @a1.scuffles[:won].size.must_equal 1
       @a2.scuffles[:won].size.must_equal 0
       
       @a1.scuffles[:won].first.must_equal @s
       @a2.scuffles[:lost].first.must_equal @s
     end

   end


end


class TestScore < MiniTest::Unit::TestCase 

  describe Score do
  
    before do 
      @value = 100
      @min = 50
      @max = 200
      @s = Score.new(@value, @min, @max)
    end
    
    it 'must be a Score' do
      @s.must_be_instance_of Score
    end
    
    it 'must keep an array of values, initialized' do
      @s.values.must_be_instance_of Array
      @s.values.count.must_equal 1
      @s.values.last.must_equal @value
    end
    
    it 'must change' do
      @s.change_by(25)
      @s.values.count.must_equal 2
      @s.value.must_equal 125
    end
    
    it 'must never be less than the set min value' do
      @s.change_by(-1000)
      @s.value.must_equal @min
    end
    
    it 'must never be more than the set max value' do
      @s.change_by(1000)
      @s.value.must_equal @max
    end
    
  end

end
