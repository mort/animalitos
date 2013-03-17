class Float 

  def precision(p = 4)
    sprintf("%.#{p}f", self).to_f
  end


end