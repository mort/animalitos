class Score

  attr_reader :values, :min, :max
  
  def initialize(value, min = 0, max = nil)
        
    @values = [value]
    @min = min
    @max = max
    
  end
  
  def change_by(increment)
    
    new_value = value + increment
    
    @values << if (new_value < @min)
      @min
    elsif (@max && (new_value > @max))
      @max
    else
      new_value
    end
    
    
  end
  
  def value 
    @values.last
  end
  
  
end