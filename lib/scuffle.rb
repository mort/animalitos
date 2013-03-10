class Scuffle 
  include Observable 
  
  attr_reader :a1, :a2, :tie, :over, :winner, :loser, :created_at, :location
  
  def initialize(participants, location) 
    
    @id = SecureRandom.uuid
    @participants = participants
    @a1,@a2 = *@participants
    @tie = false
    @over = false
    @winner = nil
    @loser = nil
    @created_at = Time.now
    @location = location

    add_observer Streamer.new
    
  end
  
  def play    
    
    case (@a1.luma <=> @a2.luma)
      when 1
        won_by(@a1)
      when -1
        won_by(@a2)
      when 0
        tie
    end
    
    (@tie == true) ? 'tie' : @winner
    # puts "Tie 2 #{tie}"
  end
  
  def won_by(a)
    @winner = a
    @loser = (@winner == @a1) ? @a2 : @a1

    @winner.scuffles[:won] << self
    @loser.scuffles[:lost] << self
    
    @over = true
  end
  
  def tie
    @tie = true 
    @over = true
  end
  
  def as_activity(participant)
    
    return false unless (@over && @participants.include?(participant))
    
    the_object = self.as_obj
    the_actor = participant.as_actor
    the_location = @location.as_place
    verb = @tie ? 'tie' : (participant == @winner) ? 'win' : 'lose'
    
    activity {
      verb  verb
      actor the_actor
      obj the_object   
      self[:location] = the_location
    }
            
  end
  
  def as_obj
    
    #place = @location.as_place
    name = "#{@a1.name} vs #{@a2.name}"
    the_id = to_param
    
    game { 
      display_name name
      id the_id
    }
  end
  
  def is_a_tie?
    @tie
  end
  
  def to_param
    @id
  end
  
  def to_iri
    "http://littlesiblings.com/iris/#{self.to_param}"
  end
  
  
end