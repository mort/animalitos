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
    
    context 'movement and checkins' do
      context 'moving with player' do
    
        before do
          @a = Animalito.new
          @p = Player.new 'mort'
          @p.bond_with(@a)
          @p.move_to(Location.new(40.425829799999995, -3.7112119000000003))
          @pos = @a.current_position
          @act = JSON.parse(@pos.as_activity.dup.to_s)
        end
      
        it 'should be a valid activity' do
          valid?(@act)
        end
      
        it 'the animalito should be the actor' do
          @act['actor']['displayName'].must_equal @a.name
        end
      
        it 'should have the right verb' do
          assert verb_is?(@act, 'at')
        end
      
        it 'should have an object' do
          assert activity_has?(@act, 'object')
          assert is_absolute_iri?(@act['object']['id'])
        end
      
        it 'should have a natural language description' do
          @act['content'].must_match /is at/
        end
      
        it 'should have the name of the player on the content' do
          s = 
          @act['content'].must_match /with/
        end
  
      end
    
      context 'moving on its own' do
    
        before do
          @a = Animalito.new
          @p = Player.new 'mort'
          @p.bond_with(@a)
          @a.unleash
          @a.move_to(Location.new(40.425829799999995, -3.7112119000000003))
          @pos = @a.current_position
          @act = JSON.parse(@pos.as_activity.dup.to_s)
        end
      
        it 'should be a valid activity' do
          valid?(@act)
        end
      
        it 'the animalito should be the actor' do
          @act['actor']['displayName'].must_equal @a.name
        end
      
        it 'should have the right verb' do
          assert verb_is?(@act, 'at')
        end
      
        it 'should have an object' do
          assert activity_has?(@act, 'object')
          assert is_absolute_iri?(@act['object']['id'])
        end
      
        it 'should have a natural language description' do
          @act['content'].must_match /is at/
        end
      
        it 'wont have the name of the player on the content' do
          @act['content'].wont_match /"#{@p.name}"/
        end
  
      end
    
      context 'checkin in with the player' do
      
        before do
          @a = Animalito.new
          @p = Player.new 'mort'
          @p.bond_with(@a)
          @p.checkin(@p.latest_venue)
          @pos = @a.current_position
          @act = JSON.parse(@pos.as_activity.dup.to_s)
        end
      
        it 'should have the right verb' do
          assert verb_is?(@act, 'checkin')
        end
      
        it 'should contain the name of the venue in the content' do
          @act['content'].must_match Regexp.new("#{@p.latest_venue['name']}")
        end
      
      end
  
    end
   
    context 'on a journey' do
      
      before do
        @a = Animalito.new
        @a.move_to(Location.new(40.425829799999995, -3.7112119000000003))
        route = Route.new(@a.current_location)
        locations = route.compute
        @journey = Journey.new(@a, locations)
        puts @journey.as_activity
        @journey.start
        @act = JSON.parse(@journey.as_activity.dup.to_s)
      end
      
      it 'should be a valid activity' do
        assert valid?(@act) 
      end

      it 'should have the right verb' do
        assert verb_is?(@act, 'start-journey')
      end
      
      it 'should have the right content' do
         @act['content'].must_match /started a walk/
       end
       
       context 'finishing' do
        
          before do 
            @journey.finish
            @act = JSON.parse(@journey.as_activity.dup.to_s)
          end
          
         it 'should be a valid activity' do
            assert valid?(@act) 
          end

          it 'should have the right verb' do
            assert verb_is?(@act, 'end-journey')
          end

          it 'should have the right content' do
             @act['content'].must_match /finished a walk/
           end
          
        
       end
       
      
    end
  
    context 'liking things' do
      
      before do 
        @animalito = Animalito.new
      end
      
      it 'liking places' do
        skip 'TODO'
      end
      
      it 'liking the weather' do
        skip 'TODO'
      end
      
      it 'liking other animalitos' do
        skip 'TODO'
      end
      
      
    end
   
    context 'energy' do
    end
   
   
    def activity_has?(act, k)
      act.keys.include? k
    end
  
  
    def valid?(a)       
      a.must_be_kind_of Hash
      assert is_absolute_iri?(a['id'])
      assert is_absolute_iri?(a['actor']['id'])  
    end
    
    def verb_is?(a, v)
      a['verb'] == v
    end
  
  end


  
end
