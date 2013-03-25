require '../test_helper.rb'
include ActivityStreams::Matchers

class TestActivities < MiniTest::Unit::TestCase
  
  
  # Wadus is born
  # Wadus is with [Player] at [Venue]
  # Wadus is now at [location]
  # Wadus is with [Player] at [location]
  # Wadus has gone for a walk
  # Wadus has finished a walk
  # Wadus [likes] [VenueCategory]
  # Wadus [likes] being at [Venue]
  # The weather is [sunny] and Wadus [likes] that.
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
      
      it 'should have the birth location' do
        @act['location'].must_equal @a.birth_location
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
        
        it 'should be a valid activity' do
          assert valid?(@act) 
        end
      
        it 'should have the right verb' do
          assert verb_is?(@act, 'checkin')
        end
      
        it 'should contain the name of the venue in the content' do
          @act['content'].must_match Regexp.new("#{@p.latest_venue.name}")
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
         @act['content'].must_match /gone for a walk/
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
        @player = Player.new 'mort'
      end
      
      context 'liking places' do
        
        before do 

          @venue = @player.latest_venue
          @liking = Liking.new(@animalito, @venue, 1)
          @act = JSON.parse(@liking.as_activity.dup.to_s)
          
        end
        
        it 'should be a valid activity' do
          assert valid?(@act)
          assert verb_is?(@act, 'likes')
        end
        
        
       it 'should contain the right verb in the content' do
           @act['content'].must_match /likes/
         end
        
        it 'should contain the name of the venue in the content' do
           @act['content'].must_match Regexp.new("#{@venue.name}")
         end
         
         context 'disliking the place' do
          
          before do  
           @liking = Liking.new(@animalito, @venue, -1)
           @act = JSON.parse(@liking.as_activity.dup.to_s)
          end
          
          it 'should be a valid activity' do
            assert valid?(@act)
            assert verb_is?(@act, 'dislikes')
          end
         
          it 'should contain the right verb in the content' do
            @act['content'].must_match /dislikes/
          end
         
            
         
         end
         
        
      end
      
      context 'liking the weather' do
       
         before do
           @animalito = Animalito.new
           @weather = Siblings::Services::Weather.new(Location.new(40.425829799999995, -3.7112119000000003))
           @liking = Liking.new(@animalito, @weather, 1)
           @act = JSON.parse(@liking.as_activity.dup.to_s)
         end
       
       
         it 'should be a valid activity' do
           assert valid?(@act)
           assert verb_is?(@act, 'likes')
         end
         
         it 'should contain the right content' do
            @act['content'].must_match /The weather is/
            @act['content'].must_match Regexp.new @animalito.name
            @act['content'].must_match /likes/
         end
     
       
       
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
      a.must_be_kind_of Hash, @a.class.to_s
      assert is_absolute_iri?(a['id']), a['id']
      assert is_absolute_iri?(a['actor']['id']), a['actor']['id']  
    end
    
    def verb_is?(a, v)
      a['verb'] == v
    end
  
  end


  
end
