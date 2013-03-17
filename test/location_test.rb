require './test_helper.rb'

class TestLocation < MiniTest::Unit::TestCase 

  describe Location do
  
    before do
      @location = Location.new(40.4091123, -3.6934069999999997)
    end
    
    it 'has to store occupants when they enter the Location' do
      @animalito = Animalito.new
      @animalito.enter_location(@location)
      @location.occupants.first.must_equal @animalito
    end
    
    it 'has to remove occupants when they leave the Location' do
      @animalito = Animalito.new
      @animalito.enter_location(Location.new(40.4491123, -3.6434069999999997))
      @location.occupants.first.wont_equal @animalito
    end
    
  
  end

end
