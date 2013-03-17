require './test_helper.rb'

class TestScuffle < MiniTest::Unit::TestCase 

  describe Scuffle do
    
      before do
        @a1 = Animalito.new
        @a2 = Animalito.new
        @l  = Location.new(0.0, 0.0)
        @s = Scuffle.new([@a1,@a2], @l)
      end
      
      it 'should be a Scuffle' do
        @s.must_be_instance_of Scuffle
      end
      
      it 'shouldnt be over (til its over)' do
        @s.over.must_equal false
      end
      
      it 'should have participants' do
        [@s.a1, @s.a2].must_equal [@a1, @a2]
      end
      
      it 'should have a Location' do
       @s.location.must_equal @l
      end
      
      it 'should end in a tie for Animalitos with the same luma' do
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

     it 'should end in a win for the Animalito with more luma' do
       @s.is_a_tie?.must_equal false
       @s.winner.must_equal @a1
       @s.loser.must_equal @a2
       @s.over.must_equal true
     end
     
     it 'should add to the Animalitos Scuffles list' do
       @a1.scuffles[:lost].size.must_equal 0
       @a2.scuffles[:lost].size.must_equal 1
       
       @a1.scuffles[:won].size.must_equal 1
       @a2.scuffles[:won].size.must_equal 0
       
       @a1.scuffles[:won].first.must_equal @s
       @a2.scuffles[:lost].first.must_equal @s
     end

   end


end

