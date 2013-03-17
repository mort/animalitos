require '../test_helper.rb'

class TestPlayer < MiniTest::Unit::TestCase

  describe Player do 
    
    before do
      @player = Player.new('mort')
    end
    
    it 'has a name' do
      @player.name.must_equal 'mort'
    end
    
    it 'has to bond with Animalitos' do
      a = Animalito.new
      @player.bond_with(a)
      @player.animalito.must_be_same_as a
    end
    
    
    it 'has to share the bond the Animalito when bonding' do
      a = Animalito.new
      @player.bond_with(a)
      a.player.to_param.must_be_same_as @player.to_param
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