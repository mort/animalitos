module Feeds
  
  LUMA_LIMIT = 500
  
  def luma 
    scores[:luma].value
  end
    
  def feed_on_img(img)
    
    feeding = Feeding.new(self, img)
    scores[:luma].change_by(feeding.feed)
    
    changed

    notify_observers feeding.as_activity
    
    feeding
    
  end
  
  def consume_luma(i = 1)
    scores[:luma].change_by(i*-1)
  end
    
end


