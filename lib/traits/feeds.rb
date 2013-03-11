module Feeds
  
  LUMA_LIMIT = 500
  LUMA_WARNINGS = [20, 10, 5]
  
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

    player.notify({:type => :luma_level, :body => luma_percentage, :created_at => Time.now}) if @bound && LUMA_WARNINGS.include?(luma_percentage)
  end
  
  def luma_percentage
    ((luma.to_f/LUMA_LIMIT.to_f)*100).to_i
  end
    
end


