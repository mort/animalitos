require '../test_helper.rb'
include ActivityStreams::Matchers

class TestActivities < MiniTest::Unit::TestCase
  
  
  # Wadus is born
  # Wadus is with you at [Venue]
  # Wadus [likes] [VenueCategory]
  # Wadus [likes] being at [Venue]
  # Wadus has gone for a walk
  # Wadus is now at [location]
  # The weather in [City] is [sunny] and Wadus [likes] that.
  # Wadus is hungry.
  # Wadus is hungry and feels tired.
  # Wadus is hungry and is about to go to sleep.
  # Wadus has gone to sleep.
  # Wadus has enjoyed a tasty meal.
  # Wadus has woken up to a tasty breakfast.
  # Wadus has met Wadus2 and Wadus likes that.
  # Wadus has got into a scuffle with Wadus2. Wadus [won|lost|tied]
  
  
  describe 'Animalito activity' do
    
    context 'birth' do
      # Wadus is born
    
      before do
        @a = Animalito.new
        @act = JSON.parse(@a.as_activity.dup.to_s)
      end
    
      it 'should be a valid activity' do
        assert valid?(@act) 
      end
    
      it 'should have the right verb' do
        assert verb_is?(@act, 'born')
      end
      
      it 'should have a natural language description' do
        @act['content'].must_match /is born/
      end
    
    end
  
    context 'with you' do
    
      before do
        @a = Animalito.new
        @p = Player.new 'mort'
        @p.bond_with(@a)
        @p.move_to(Location.new(0.0,0.0))
        @pos = @p.current_position
        @act = JSON.parse(@pos.as_activity.dump.to_s)
      end
      
      it 'should be a valid activity' do
        assert valid?(@act), @act.to_s 
      end
      
    
    end
  
    def valid?(a) 
      a.must_be_kind_of Hash
      #assert is_absolute_iri?(a['id'])
    end
    
    def verb_is?(a, v)
      a['verb'] == v
    end
  
  end


  
end
