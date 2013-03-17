module Siblings

  class Scuffle 
    include Observable 
    include Streamable::Scuffle
  
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

      add_observer Streamable::Streamer.new
    
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
  
    def is_a_tie?
      @tie
    end
  

  end
end