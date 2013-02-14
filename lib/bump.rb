class Bump
  include Observable 
  
  
  def initialize(animalitos)
    @id = SecureRandom.uuid
    @animalitos = animalitos
    
    add_observer Announcer.new

  end
  
  def crash
    @animalitos.each { |a| a.bumps << self }
    bumpers = @animalitos.map(&:to_param).join(', ')    
    
    changed
    
    notify_observers(self, "#{bumpers} bumped their heads!", :bump)	
  end
  
  def to_param
    id
  end
  
end