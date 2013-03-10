module Feeder
  
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


class Feeding

  def initialize(animalito, img)
    @animalito = animalito
    @img = img
    @luma_value = nil
  end
  
  def feed
    @luma_value ||= Luma.new(@img).to_i 
    increment = @luma_value
    
    @luma_value = @luma_value / 2
    
    increment
  end

  def as_activity
  
    the_actor = @animalito.as_actor
    the_url = "http://littlesiblings.com/api/feedings/#{@image}"
        
    activity {
      verb 'feed'
      actor the_actor
      obj image {
        url the_url
      }
    }
    
    
  end

end