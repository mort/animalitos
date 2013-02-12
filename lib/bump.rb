class Bump
  include Observable 
  
  
  def initialize(animalitos)
    id = 
    @animalitos = animalitos
    bumpers = @animalitos.map(&:to_param).join(', ')
    
    @animalitos.each { |a| a.bumps << self }

    add_observer Announcer.new
    
    changed
    
    notify_observers(self, "#{bumpers} bumped their heads!", :bump)		
    
    
  end
  
  def to_param
    'foo'
  end
  
end