require './test_helper.rb'
require './test_helper.rb'

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
    
    it 'has an Animalito' do
      @j.animalito.must_be_same_as @a
    end
  
    it 'has Locations' do
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