require 'pry'

require 'minitest/spec'
require 'minitest/autorun' 
require 'minitest-spec-context'

require '../animals.rb'

Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }

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
    
    
    it 'has to bond the animalito with self when bonding' do
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
      @animalito.bond_with(p)
      @animalito.player.must_be_same_as p
    end
    
    it 'has to go with the player when bound' do
      p = Player.new('mort')
      l =  Location.new(40.4091123, -3.6934069999999997)
      p.bond_with(@animalito)
    
      p.move_to(l)
      @animalito.current_location.must_be_same_as l
    end
    
    context 'moving' do
      
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

class TestRouteMaker < MiniTest::Unit::TestCase  
  
  describe RouteMaker do
  
    before do
      @l1 = Location.new(40.4091123, -3.6934069999999997)
      @l2 = Location.new(40.4091200, -3.6934100000200002)

      @rm = RouteMaker.new(@l1, @l2)
    end
    
    it 'has to be valid' do
      @rm.must_be_instance_of RouteMaker
    end
    
    it 'has to have start/end locations' do
      
      @rm.start_location.must_be :===, @l1
      @rm.end_location.must_be :===, @l2
      
    end
  
    it 'has a default strategy' do
      @rm.strategy.must_equal :linear
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
    
    
  
    
  end
  
  
end

class TestJourney < MiniTest::Unit::TestCase 
  
  describe Journey do
    
    before do
      l1 = Location.new(40.4091123, -3.6934069999999997)
      l2 = Location.new(40.4091200, -3.6934100000200002)

      rm = RouteMaker.new(l1, l2)
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