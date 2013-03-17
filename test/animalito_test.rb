require './test_helper.rb'

class TestAnimalito < MiniTest::Unit::TestCase
  
  describe Animalito do
  
    before do
      @animalito = Animalito.new
    end
    
    it 'is a class' do
      @animalito.class.must_equal Animalito
    end

    it 'has a new method' do
      @animalito.class.must_respond_to 'new'
    end
    
    it 'has a name' do
      @animalito.name.wont_be_empty
    end
    
    it 'has to bond with player' do
      p = Player.new('mort')
      p.bond_with(@animalito)
      @animalito.player.wont_equal nil
      @animalito.player.to_param.must_equal p.to_param
    end
    
    it 'has to have a birth Location when hatched by a Player' do
      p = Player.new('mort')
      l = Location.new(40.4091123, -3.6934069999999997)
      p.move_to(l)
      a = p.hatch
      a.birth_location.must_be_same_as l
    end
    
    it 'has to move to the Players Location after hatched' do
      p = Player.new('mort')
      l = Location.new(40.4091123, -3.6934069999999997)
      p.move_to(l)
      a = p.hatch
      a.current_location.must_be_same_as p.current_location
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
      
      it 'has to have the right current Location' do
        @animalito.current_location.must_equal @l
      end
      
      it 'will bump' do
        @animalito2 = Animalito.new
        @animalito2.enter_location(@animalito.current_location)
        @animalito.bumps.count.must_equal 1
        @animalito.bumps.first.must_be_instance_of Bump
      end
      
      it 'will wander' do
        @animalito.wander
        @animalito.journeys.wont_be_empty
        @animalito.last_journey.must_be_instance_of Journey
        @animalito.last_journey.open.must_equal false
      end 
      
      it 'will go back to the Player after wandering if roundtrip specified' do
        player = Player.new('wadus')
        player.bond_with(@animalito)
        player.move_to(@l)
        @animalito.leashed = false
        @animalito.wander(:journey => {:roundtrip => true})
        @animalito.current_location.must_equal @animalito.player.current_location
      end
      
      it 'wont go back to the Player after wandering if no roundtrip specified' do
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
      
      it 'should notify the Player if bound and on a warn level' do
        p = Player.new('mort')
        p.bond_with(@animalito)
        @animalito.consume_luma(50)
        p.inbox.count.must_equal 1
        p.inbox.first[:subject].must_equal :luma_level

      end
            
      it 'should go to sleep when luma is zero' do
        @animalito.consume_luma(@animalito.luma)
        @animalito.awake?.must_equal false
        @animalito.sleeping?.must_equal true
      end
      
      it 'wont wake up if luma is between zero and the minimum level' do
        @animalito.consume_luma(@animalito.luma)
        @animalito.add_luma(3)
        @animalito.luma.must_equal 3
        @animalito.awake?.must_equal false
        @animalito.sleeping?.must_equal true
      end
      
      it 'should consume luma' do
        @animalito.consume_luma(@animalito.luma)
        @animalito.luma.must_equal 0
      end
      
      it 'should add luma' do
        @animalito.consume_luma(@animalito.luma)
        @animalito.add_luma(Traits::Feeds::LUMA_WARN_LEVELS.first)
        @animalito.luma.must_equal Traits::Feeds::LUMA_WARN_LEVELS.first
      end
      
      it 'should know when it has NOT enough luma' do
        @animalito.consume_luma(@animalito.luma)
        @animalito.enough_luma?.must_equal false
      end
      
      it 'should know when it has enough luma' do
        @animalito.consume_luma(@animalito.luma)
        @animalito.add_luma(Traits::Feeds::LUMA_WARN_LEVELS.first)
        @animalito.enough_luma?.must_equal true
      end
      
      it 'should wake up when it has enough luma' do
        @animalito.consume_luma(@animalito.luma)
        @animalito.add_luma(Traits::Feeds::LUMA_WARN_LEVELS.first)
        @animalito.awake?.must_equal true
      end
    
    
    end
  
  
  end
  
end
