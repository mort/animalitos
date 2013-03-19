class Array

  def upperleft

    top = self.first

    self.each do |loc|
      top = loc if loc.lat > top.lat || (loc.lat == top.lat && loc.lon < top.lon)
    end

    top

  end unless method_defined?(:upperleft)

  def sort_clockwise!
  
    upper = self.upperleft
    sort! { |a,b| a.send('<=>', b, upper) }
  
  end unless method_defined?(:sort_clockwise!)

end