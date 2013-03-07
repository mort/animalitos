class Scuffle 
  include Observable 
  
  def initialize(participants, location) 
    
    @participants = participants
    @a1,@a2 = *@participants
    @tie = @over = false
    @winner = @loser = nil
    @created_at = Time.now
    @location = location

    add_observer Announcer.new
    
    
  end
  
  def play
    
    case (@a1.lumma <=> @a2.lumma)
      when 1
        won_by(@a1)
      when -1
        won_by(@a2)
      when 0
        tie
    end
  end
  
  def won_by(a)
    @winner = a
    @loser = (@winner == @a1) ? @a2 : @a1

    @winner.scuffles[:won] << self
    @loser.scuffles[:lost] << self
    
    @over = true
  end
  
  def tie
    @tie = @over = true
  end
  
  def as_activity(v)
    
    return false unless %w(win lose).includes(v)
    
    actor = (v == 'win' ? @winner : @loser).as_actor
    object = self.as_object
    
    verb = "ActivityStreams::Verb::#{v.capitalize}".constantize.new  

    
    activity = ActivityStreams::Activity.new(
      :actor  => actor,
      :object => object,
      :verb   => verb,
      :published => Time.now.utc,
      :location => @location.as_place
    )
      
  end
  
  def as_object
    
  end
  
  
end