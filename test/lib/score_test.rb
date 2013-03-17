require '../test_helper.rb'

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
