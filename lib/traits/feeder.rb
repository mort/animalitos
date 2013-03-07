module Feeder
  
  LUMA_LIMIT = 500
  
  def feed_on_img(img)
    
    
    @luma_values[img] ||= Luma.new(img).to_i 
    
    increment = @luma_values[img]

    puts "Current luma of #{name}: #{@luma}"
    puts "Lumic value of #{img}: #{increment}"
    
    puts "No luma! #{img} is useless now." if increment < 1
    
    return false if (increment < 1 || @luma >= LUMA_LIMIT)
    
    new_luma = @luma + increment
    @luma = (new_luma < LUMA_LIMIT) ? new_luma : LUMA_LIMIT
    
    changed

    puts s = "Fed! Luma of #{name} is now #{@luma}"
    notify_observers(self, s, :feed)
    
    @luma_values[img] = increment / 2

    @luma
    
  end
  
  def consume_luma(i = 1)
    @luma = (@luma > i) ? @luma - i : 0
  end
    
end