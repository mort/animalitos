require '../test_helper.rb'

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
    
    it 'has to have start/end Locations' do
      
      @rm.start_location.must_be :===, @l1
      @rm.end_location.must_be :===, @l2
      
    end
  
    it 'has to call the default computing method for strategy' do
      @rm.compute
      assert_send [@rm, :compute_linear]
    end
  
    it 'has to compute an array of Locations (linear)' do
      locations = @rm.compute
      locations.must_be_instance_of Array
      locations.size.must_be :>, 1
      locations.first.must_be_instance_of Location
      locations.last.must_be_instance_of Location
    end
    
    it 'has to compute an array of Locations (random bbox)' do
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