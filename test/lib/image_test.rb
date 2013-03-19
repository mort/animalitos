require '../test_helper.rb'

class TestImage < MiniTest::Unit::TestCase
  
  describe Image do
  
    it 'has a src' do
      img = Image.new('/foo.jpg')
      img.src.must_equal '/foo.jpg'
    end
  
  end


end
