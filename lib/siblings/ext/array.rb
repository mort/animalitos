class Array

  def upperleft

    top = self.first

    self.each do |loc|
      top = loc if loc.lat > top.lat || (loc.lat == top.lat && loc.lon < top.lon)
    end

    top

  end

  def sort_clockwise!
    upper = self.upperleft
    sort! { |a,b| a.send('<=>', b, upper) }
  end

end