module Feeds
  
  LUMA_LIMIT = 500
  LUMA_WARN_LEVELS = [5, 10, 20]
  
  def luma 
    scores[:luma].value
  end
    
  def feed_on_img(img)
    
    feeding = Feeding.new(self, img)
    add_luma(feeding.feed)

    changed
    notify_observers feeding.as_activity
    
    feeding
    
  end
  
  def add_luma(i = 1) 
    scores[:luma].change_by(i)
    wake_up if sleeping? && enough_luma?
  end
  
  def consume_luma(i = 1)
    
    scores[:luma].change_by(i*-1)
    go_to_sleep if awake? && no_luma? 
     
    if @bound && LUMA_WARN_LEVELS.include?(luma_percentage)
      msg = Message[self, :luma_level, luma_percentage, Time.now]   
      player.notify(msg) 
    end
    
  end
  
  def luma_percentage
    ((luma.to_f/LUMA_LIMIT.to_f)*100).to_i
  end
  
  def no_luma?
    luma == 0
  end
  
  def enough_luma?
    luma >= LUMA_WARN_LEVELS.first
  end
  
  def go_to_sleep
    @sleeping = true
  end
  
  def wake_up
    @sleeping = false
  end
  
  def sleeping?
    @sleeping == true
  end
  
  def awake?
    !sleeping?
  end
    
end


