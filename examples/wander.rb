 require '../siblings.rb'


p = Player.new('mort')
puts "+ A new player named "+p.name

a = Animalito.new

puts "+ And a new animalito named "+a.name

p.bond_with(a)

puts "+ are now bonded"

p.move_to(Location.new(40.418944, -3.704611))

puts "Player and Animalito are now at #{p.current_location.lat}, #{p.current_location.lon}"

a.unleash
puts "Animalito is now unleashed"

a.wander :route => {:strategy => 'clockwise_in_bbox', :points => 5, :radius => 0.3}, :journey => {:roundtrip => true, :speed => 1}
puts "Animalito has gone for a walk"

a.leash

p.move_to(Location.new(40.42562151314903, -3.7114182114601135))

a.wander :route => {:strategy => 'linear', :points => 5, :radius => 0.3}, :journey => {:speed => 1}
