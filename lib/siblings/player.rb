module Siblings

  class Player
    
    include Celluloid
    include Observable
    
    include Traits::Moves
    include Services::Foursquare

    include Streamable::Player  

  	attr_reader :name, :bond, :positions, :inbox, :timer, :latest_venue_id, :following
  	
  	delegate :animalito, :to => :bond, :allow_nil => true
    
  	def initialize(name, options = {})

      @uuid = SecureRandom.uuid
  		@name = name
  		@bond = nil
  		@positions = []
      @latest_venue_id = nil
    
      @inbox = Inbox.new(self)
    
  		add_observer Streamable::Streamer.new
		
  		@timer = after(90) { checkin! } if options[:autocheckin]
  		    
  	end
	
	  def bound?
      !@bond.nil?
    end
	
	  def significant_other
	    return nil unless bound?
      animalito
    end
	
  	def notify(msg)
      @inbox << msg
    end

    def move_to(location, options = {})
	  
  	  options[:leashed] ||= true
	  
  	  super
  	  animalito.move_to(location, options) if animalito && options[:leashed] && animalito.leashed
  	  current_position
    end

  	def hatch
  	  return if bound?
      bond_with(Animalito.new(:location => current_location))
      
      changed
      notify_observers @bond.as_activity
      
      animalito
      
    end

  	def bond_with(animalito)
  	  raise 'Already bonded' if bound?

      @bond = Bond.new(self, animalito)
  		animalito.share_bond(@bond)

  		# Player should follow its animalito
      #follow(@animalito)

  		changed
  		#notify_observers @bond.as_activity('player')

  		animalito
  	end
	
  	def unbond
  	  @bond = nil
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
      @uuid
    end
  
  end

end
