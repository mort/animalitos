module Siblings

  class Player
    
    include Celluloid
    include Observable
    
    include Traits::Moves
    include Services::Foursquare

    include Streamable::Player  

  	attr_reader :name, :bond, :positions, :bound, :inbox, :timer, :latest_venue_id, :following
  	
  	delegate :animalito, :to => :bond, :allow_nil => true
    

  	def initialize(name, options = {})

      @id = SecureRandom.uuid
  		@name = name
  		@bond = nil
  		@positions = []
      @bound = false
      @latest_venue_id = nil
    
      @inbox = Inbox.new(self)
    
  		add_observer Streamable::Streamer.new
		
  		@timer = after(90) { checkin! } if options[:autocheckin]
  		    
  	end
	
  	def notify(msg)
      @inbox << msg
    end

    def move_to(location, options = {})
	  
  	  options[:with_animalito] ||= true
	  
  	  super
  	  animalito.move_to(location, options) if animalito && options[:with_animalito] && animalito.leashed
  	  current_position
    end

  	def hatch
  	  return if @bound
      bond_with(Animalito.new(:location => current_location))
      
      changed
      notify_observers @bond.as_activity
      
      animalito
      
    end

  	def bond_with(animalito)
  	  raise 'Already bonded' if @bound

      @bond = Bond.new(self, animalito)
  		animalito.share_bond(@bond)
  		@bound = true

  		# Player should follow its animalito
      #follow(@animalito)

  		changed
  		#notify_observers @bond.as_activity('player')

  		animalito
  	end
	
  	def unbond
  	  @bond = nil
  	  @bound = false
    end
  
  
    def follow(follower)
      @following ||= {}
      
      k = follower.class.to_s.downcase.gsub!('::','_').to_sym
      
      @following[k] ||= []
      @following[k][follower.to_param] = follower
    end
    
    def unfollow(follower)
      k = follower.class.to_s.downcase.split('::').last.to_sym
      @following[k].delete(follower.to_param)
    end
    
    
    def to_param
      name
    end
  
  end

end